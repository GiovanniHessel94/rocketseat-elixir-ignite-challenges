defmodule ListFilter do
  def call(list) do
    parse_integers(list)
    |> filter_strings()
    |> count_odd()
  end

  defp parse_integers(list) do
    Enum.map(list, fn element ->
      Integer.parse(element)
      |> handle_parse
    end)
  end

  defp filter_strings(list) do
    Enum.filter(list, fn element -> is_integer(element) end)
  end

  defp count_odd(list) do
    Enum.count(list, fn integer -> Integer.mod(integer, 2) == 1 end)
  end

  defp handle_parse({value, ""}), do: value

  defp handle_parse({_value, _decimals}), do: ""

  defp handle_parse(:error), do: ""
end
