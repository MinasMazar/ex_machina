defmodule ExMachinaTest do
  use ExUnit.Case
  doctest ExMachina

  test "greets the world" do
    assert ExMachina.hello() == :world
  end
end
