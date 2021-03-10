defmodule ListLengthTest do
  use ExUnit.Case

  describe "testing ListLength module" do
    test "Should return the 2 when the list contains two elements" do
      list = [30, 45]

      response = ListLength.call(list)

      expected_response = 2

      assert response == expected_response
    end

    test "Should return the 0 when the list do not contains any elements" do
      list = []

      response = ListLength.call(list)

      expected_response = 0

      assert response == expected_response
    end
  end
end
