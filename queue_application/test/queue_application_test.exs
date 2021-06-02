defmodule QueueApplicationTest do
  use ExUnit.Case
  doctest QueueApplication

  test "greets the world" do
    assert QueueApplication.hello() == :world
  end
end
