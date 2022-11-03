defmodule ExMachinaTest do
  use ExUnit.Case
  doctest ExMachina
  doctest ExMachina.Tape
  doctest ExMachina.State
  doctest ExMachina.Program
  doctest ExMachina.Engine

  setup :machine_fixture

  test "executing a Turing machine step by step", %{machine: {tape, state, program}} do
    {tape, state, _} = ExMachina.Engine.step({tape, state, program})
    assert ExMachina.Tape.to_list(tape) == ~w[A b c d]
    assert state == 0

    {tape, state, _} = ExMachina.Engine.step({tape, state, program})
    assert ExMachina.Tape.to_list(tape) == ~w[A B c d]
    assert state == 0

    {tape, state, _} = ExMachina.Engine.step({tape, state, program})
    assert ExMachina.Tape.to_list(tape) == ~w[A B C d]
    assert state == 0

    {tape, state, _} = ExMachina.Engine.step({tape, state, program})
    assert ExMachina.Tape.to_list(tape) == ~w[A B C D]
    assert state == -1
  end

  test "executing a Turing machine program until final state", %{machine: {tape, state, program}} do
    {tape, state, _} = ExMachina.Engine.run({tape, state, program})
    assert ExMachina.Tape.to_list(tape) == ~w[A B C D]
    assert state == -1
  end

  defp machine_fixture(_) do
    tape = ExMachina.Tape.create(["a", "b", "c", "d"])
    program = [
      {{"a", 0}, {"A", 0, :right}},
      {{"b", 0}, {"B", 0, :right}},
      {{"c", 0}, {"C", 0, :right}},
      {{"d", 0}, {"D", -1, nil}},
    ]
    {:ok, machine: {tape, 0, program}}
  end
end
