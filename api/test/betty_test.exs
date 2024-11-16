defmodule BettyTest do
  use ExUnit.Case
  doctest Betty

  test "greets the world" do
    assert Betty.hello() == :world
  end
end
