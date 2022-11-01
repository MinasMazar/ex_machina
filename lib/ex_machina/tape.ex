defmodule ExMachina.Tape do
  @moduledoc """
  Turing Machine tape.

  ## Example

  iex> tape = ExMachina.Tape.create([1,2,3,4])
  [[], 1, [2,3,4]]
  iex> tape = ExMachina.Tape.left(tape)
  iex> tape = ExMachina.Tape.left(tape)
  iex> ExMachina.Tape.get(tape)
  nil
  iex> tape = ExMachina.Tape.left(tape)
  iex> tape = ExMachina.Tape.left(tape)
  iex> ExMachina.Tape.get(tape)
  nil
  iex> tape = ExMachina.Tape.put(tape, :first)
  iex> ExMachina.Tape.get(tape)
  :first
  iex> tape = ExMachina.Tape.right(tape)
  iex> tape = ExMachina.Tape.right(tape)
  iex> tape = ExMachina.Tape.right(tape)
  iex> ExMachina.Tape.get(tape)
  nil
  iex> tape = ExMachina.Tape.right(tape)
  iex> ExMachina.Tape.get(tape)
  1
  iex> tape = ExMachina.Tape.right(tape)
  iex> tape = ExMachina.Tape.put(tape, :second)
  iex> ExMachina.Tape.get(tape)
  :second
  iex> tape = ExMachina.Tape.move(tape, :left)
  iex> ExMachina.Tape.get(tape)
  1
  iex> tape = ExMachina.Tape.move(tape, :right)
  iex> ExMachina.Tape.get(tape)
  :second
  iex> tape = ExMachina.Tape.move(tape, nil)
  iex> ExMachina.Tape.get(tape)
  :second
  """
  def create([pos | rest]), do: [[], pos, rest]

  def get([_, pos, _]), do: pos
  def put([left, _, right], symbol), do: [left, symbol, right]

  def left([[], pos, right]), do: [[], nil, [pos | right]]
  def left([[left | rest], pos, right]), do: [rest, left, [pos | right]]
  def right([left, pos, []]), do: [[pos | left], nil, []]
  def right([left, pos, [right | rest]]), do: [[pos | left], right, rest]

  def move(tape, :left), do: left(tape)
  def move(tape, :right), do: right(tape)
  def move(tape, _), do: tape

  def to_list([left, pos, right]), do: Enum.reverse(left) ++ [pos] ++ right

  defimpl Inspect do
    def inspect(tape, _options) do
      Tape.to_list(tape)
    end
  end
end
