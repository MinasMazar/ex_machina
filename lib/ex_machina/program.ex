defmodule ExMachina.Program do
  @moduledoc """
  Turing Machine program.

  ## Example

  iex> valid_step = {{:tape, :state}, {:tape, :state, :mov}}
  iex> invalid_step = {{:tape, :state}, {:tape, :state}}
  iex> ExMachina.Program.valid?(valid_step)
  true
  iex> ExMachina.Program.valid?(invalid_step)
  false
  iex> valid_program = [valid_step, valid_step, valid_step]
  iex> invalid_program = [valid_step, invalid_step, valid_step]
  iex> ExMachina.Program.valid?(valid_program)
  true
  iex> ExMachina.Program.valid?(invalid_program)
  false
  """

  def valid?({{_,_}, {_, _, _}}), do: true
  def valid?(program) when is_list(program) do
    Enum.all?(program, &(valid?(&1)))
  end
  def valid?(_), do: false
end
