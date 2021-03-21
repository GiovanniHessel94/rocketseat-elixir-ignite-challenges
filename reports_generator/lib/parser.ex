defmodule ReportsGenerator.Parser do
  def parse_file(filename) when is_bitstring(filename) do
    result =
      "reports/#{filename}.csv"
      |> File.stream!()
      |> Stream.map(fn line -> parse_line(line) end)

    {:ok, result}
  end

  def parse_file(_filename), do: {:error, "Please provide a file name as string"}

  defp parse_line(line) do
    line
    |> String.trim()
    |> String.downcase()
    |> String.split(",")
    |> parse_values()
  end

  defp parse_values(list) do
    Enum.map(list, fn elem ->
      case Integer.parse(elem) do
        {integer, ""} -> integer
        _ -> String.to_atom(elem)
      end
    end)
  end
end
