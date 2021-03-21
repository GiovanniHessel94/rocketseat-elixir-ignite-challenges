defmodule ReportsGeneratorTest do
  use ExUnit.Case

  describe "build/1" do
    test "when filename is correct, returns the report" do
      filename = "data_test"

      response =
        filename
        |> ReportsGenerator.build()

      expected_response = %{
        all_hours: %{
          cleiton: 4,
          daniele: 21,
          giuliano: 10,
          jakeliny: 14,
          joseph: 3,
          mayk: 5
        },
        hours_per_month: %{
          cleiton: %{
            junho: 4
          },
          daniele: %{
            abril: 7,
            dezembro: 5,
            junho: 1,
            maio: 8
          },
          giuliano: %{
            abril: 1,
            fevereiro: 9
          },
          jakeliny: %{
            julho: 8,
            março: 6
          },
          joseph: %{
            março: 3
          },
          mayk: %{
            dezembro: 5
          }
        },
        hours_per_year: %{
          cleiton: %{
            2016 => 3,
            2020 => 1
          },
          daniele: %{
            2016 => 10,
            2017 => 3,
            2018 => 7,
            2020 => 1
          },
          giuliano: %{
            2017 => 3,
            2019 => 6,
            2020 => 1
          },
          jakeliny: %{
            2017 => 8,
            2019 => 6
          },
          joseph: %{
            2017 => 3
          },
          mayk: %{
            2017 => 1,
            2019 => 4
          }
        }
      }

      assert response == expected_response
    end

    test "when filename is not a string, returns an error" do
      filename = true

      response =
        filename
        |> ReportsGenerator.build()

      expected_response = {:error, "Please provide a file name as string"}

      assert response == expected_response
    end
  end
end
