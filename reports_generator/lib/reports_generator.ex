defmodule ReportsGenerator do
  alias ReportsGenerator.Parser

  @months {
    :janeiro,
    :fevereiro,
    :março,
    :abril,
    :maio,
    :junho,
    :julho,
    :agosto,
    :setembro,
    :outubro,
    :novembro,
    :dezembro
  }

  def build(filename) do
    filename
    |> Parser.parse_file()
    |> handle_parse()
  end

  defp handle_parse({:ok, content}), do: Enum.reduce(content, report_acc(), &aggregate_line/2)
  defp handle_parse({:error, _reason} = error), do: error

  defp report_acc, do: %{all_hours: %{}, hours_per_month: %{}, hours_per_year: %{}}

  defp aggregate_line([name, worked_hours, _day, month, year], report) do
    all = sum_hours(report.all_hours, name, worked_hours)
    per_month = sum_hours(report.hours_per_month, name, elem(@months, month - 1), worked_hours)
    per_year = sum_hours(report.hours_per_year, name, year, worked_hours)

    %{all_hours: all, hours_per_month: per_month, hours_per_year: per_year}
  end

  defp sum_hours(map, key, worked_hours) do
    {_, result} =
      Map.get_and_update(map, key, fn total_worked_hours ->
        case total_worked_hours do
          nil -> {nil, worked_hours}
          total_worked_hours -> {total_worked_hours, total_worked_hours + worked_hours}
        end
      end)

    result
  end

  defp sum_hours(map, key, attribute_key, worked_hours) do
    {_, result} =
      Map.get_and_update(map, key, fn key_map ->
        case key_map do
          nil ->
            {nil, %{attribute_key => worked_hours}}

          key_map ->
            result = sum_hours(key_map, attribute_key, worked_hours)
            {key_map, result}
        end
      end)

    result
  end
end
