defmodule ReportsGeneratorParallelismTest.ParserTest do
  use ExUnit.Case

  alias ReportsGeneratorParallelism.Parser

  describe "parse_file/1" do
    test "when filename is correct, returns the file content" do
      filename = "data_test"

      response =
        filename
        |> Parser.parse_file()
        |> elem(1)
        |> Enum.map(& &1)

      expected_response = [
        [:daniele, 7, 29, 4, 2018],
        [:mayk, 4, 9, 12, 2019],
        [:daniele, 5, 27, 12, 2016],
        [:mayk, 1, 2, 12, 2017],
        [:giuliano, 3, 13, 2, 2017],
        [:cleiton, 1, 22, 6, 2020],
        [:giuliano, 6, 18, 2, 2019],
        [:jakeliny, 8, 18, 7, 2017],
        [:joseph, 3, 17, 3, 2017],
        [:jakeliny, 6, 23, 3, 2019],
        [:cleiton, 3, 20, 6, 2016],
        [:daniele, 5, 1, 5, 2016],
        [:giuliano, 1, 2, 4, 2020],
        [:daniele, 3, 5, 5, 2017],
        [:daniele, 1, 26, 6, 2020]
      ]

      assert response == expected_response
    end

    test "when filename is not a string, returns an error" do
      filename = ["data_test"]

      response = Parser.parse_file(filename)

      expected_response = {:error, "Please provide a file name as string"}

      assert response == expected_response
    end
  end
end
