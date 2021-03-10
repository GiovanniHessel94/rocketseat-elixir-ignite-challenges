defmodule ListLength do
  def call(list), do: length(list, 0)

  defp length([], acc), do: acc

  defp length([_head | tail], acc) do
    length(tail, acc + 1)
  end
end
