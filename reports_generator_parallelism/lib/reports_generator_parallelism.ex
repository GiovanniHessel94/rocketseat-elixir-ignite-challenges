defmodule ReportsGeneratorParallelism do
  alias ReportsGeneratorParallelism.Parser

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

  def build_from_many(filenames) when is_list(filenames) do
    filenames
    |> Task.async_stream(&build/1)
    |> Enum.reduce(report_acc(), fn {:ok, report}, reports ->
      aggregate_reports(report, reports)
    end)
  end

  def build_from_many(_filenames), do: {:error, "Please provide a list of strings"}

  defp build(filename) do
    filename
    |> Parser.parse_file()
    |> handle_parse()
  end

  defp report_acc, do: %{all_hours: %{}, hours_per_month: %{}, hours_per_year: %{}}

  defp aggregate_reports(
         %{
           all_hours: all_hours1,
           hours_per_month: hours_per_month1,
           hours_per_year: hours_per_year1
         },
         %{
           all_hours: all_hours2,
           hours_per_month: hours_per_month2,
           hours_per_year: hours_per_year2
         }
       ) do
    all = merge_maps(all_hours1, all_hours2)
    per_month = merge_maps(hours_per_month1, hours_per_month2)
    per_year = merge_maps(hours_per_year1, hours_per_year2)

    build_report(all, per_month, per_year)
  end

  defp handle_parse({:ok, content}), do: Enum.reduce(content, report_acc(), &aggregate_line/2)
  defp handle_parse({:error, _reason} = error), do: error

  defp merge_maps(map1, map2) do
    Map.merge(map1, map2, fn _key, value1, value2 ->
      if is_map(value1) and is_map(value2) do
        merge_maps(value1, value2)
      else
        value1 + value2
      end
    end)
  end

  defp aggregate_line([name, worked_hours, _day, month, year], report) do
    all = sum_hours(report.all_hours, name, worked_hours)
    per_month = sum_hours(report.hours_per_month, name, elem(@months, month - 1), worked_hours)
    per_year = sum_hours(report.hours_per_year, name, year, worked_hours)

    build_report(all, per_month, per_year)
  end

  defp build_report(all_hours, hours_per_month, hours_per_year) do
    %{all_hours: all_hours, hours_per_month: hours_per_month, hours_per_year: hours_per_year}
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
