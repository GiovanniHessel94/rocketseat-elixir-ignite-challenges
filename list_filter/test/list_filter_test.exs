defmodule ListFilterTest do
  use ExUnit.Case

  describe "testing ListFilter module" do
    test "should return zero when there is not integers in the list" do
      list = ["1.5", "banana", "true", "/", "elixir", "#NeverStopLearning"]

      response = ListFilter.call(list)

      expected_response = 0

      assert response == expected_response
    end

    test "should return zero when there is not odd numbers in the list" do
      list = ["500000", "0", "true", "4", "elixir", "#NeverStopLearning", "88"]

      response = ListFilter.call(list)

      expected_response = 0

      assert response == expected_response
    end

    test "should return 3 when there is three odd numbers in the list" do
      list = ["1", "banana", "true", "6000015123300001", "elixir", "#NeverStopLearning", "999"]

      response = ListFilter.call(list)

      expected_response = 3

      assert response == expected_response
    end
  end
end
