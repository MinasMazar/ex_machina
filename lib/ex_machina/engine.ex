defmodule ExMachina.Engine do
  require Logger

  alias ExMachina.{Tape, State, Program}

  @moduledoc """
  Turing Machine engine.

  ## Example

  iex> tape = ExMachina.Tape.create([1,2,3,4])
  iex> state = 0
  iex> step = {{1, 0}, {:first, 1, :right}}
  iex> program = [step]
  iex> {tape, state, _} = ExMachina.Engine.step({tape, state, program})
  iex> ExMachina.Tape.get(tape)
  2
  iex> state
  1
  """

  def run({tape, state, program} = machine) do
    with {tape, state, program} <- step(machine) do
      if State.final?(state) do
        {tape, state, program}
      else
        run({tape, state, program})
      end
    end
  end

  def step({:error, payload}), do: {:error, payload}
  def step({tape, state, program}) do
    with symbol <- Tape.get(tape),
         {_, {out_symbol, out_state, mov}} <- find_step({symbol, state}, program) do
      out_tape =
        tape
        |> Tape.put(out_symbol)
        |> Tape.move(mov)

      Logger.info("[#{inspect tape}]")
      Logger.info("{#{inspect symbol}, #{inspect state}} -> {#{inspect out_symbol}, #{inspect out_state}, #{inspect mov}}")
      Logger.info("[#{inspect out_tape}]\n")

      {out_tape, out_state, program}
    end
  end

  defp find_step(_, step) when is_tuple(step), do: step
  defp find_step({symbol, state}, program) when is_list(program) do
    case Enum.find(program, fn {input, _} -> eq_step?(input, {symbol, state}) end) do
      step when is_tuple(step) -> step
      _ -> {:error, {symbol, state}}
    end
  end

  defp eq_step?({symbol1, state1}, {symbol2, state2}) do
    (symbol1 == symbol2) && (state1 == state2)
  end
end
