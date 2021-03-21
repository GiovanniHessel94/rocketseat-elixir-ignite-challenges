defmodule ReportsGeneratorParallelismTest do
  use ExUnit.Case

  describe "build_from_many/1" do
    test "when filenames is correct, returns the report" do
      filenames = ["data_test", "data_test", "data_test"]

      response = ReportsGeneratorParallelism.build_from_many(filenames)

      expected_response = %{
        all_hours: %{
          cleiton: 12,
          daniele: 63,
          giuliano: 30,
          jakeliny: 42,
          joseph: 9,
          mayk: 15
        },
        hours_per_month: %{
          cleiton: %{
            junho: 12
          },
          daniele: %{
            abril: 21,
            dezembro: 15,
            junho: 3,
            maio: 24
          },
          giuliano: %{
            abril: 3,
            fevereiro: 27
          },
          jakeliny: %{
            julho: 24,
            março: 18
          },
          joseph: %{
            março: 9
          },
          mayk: %{
            dezembro: 15
          }
        },
        hours_per_year: %{
          cleiton: %{
            2016 => 9,
            2020 => 3
          },
          daniele: %{
            2016 => 30,
            2017 => 9,
            2018 => 21,
            2020 => 3
          },
          giuliano: %{
            2017 => 9,
            2019 => 18,
            2020 => 3
          },
          jakeliny: %{
            2017 => 24,
            2019 => 18
          },
          joseph: %{
            2017 => 9
          },
          mayk: %{
            2017 => 3,
            2019 => 12
          }
        }
      }

      assert response == expected_response
    end

    test "when filenames is not a list, returns an error" do
      filenames = "data_test"

      response = ReportsGeneratorParallelism.build_from_many(filenames)

      expected_response = {:error, "Please provide a list of strings"}

      assert response == expected_response
    end
  end
end
