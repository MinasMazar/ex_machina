defmodule ExMachina do
  @moduledoc """
  Documentation for `ExMachina`.
  """

  use GenServer

  alias ExMachina.{Tape, State, Program, Engine}

  def start_link(tape, program) do
    GenServer.start_link(__MODULE__, {tape, program})
  end

  def init({tape, program}) do
    with tape <- Tape.create(tape), state <- 0 do
      if Program.valid?(program) do
        {:ok, {tape, state, program}}
      else
        {:error, :invalid_program}
      end
    end
  end

  def start(pid) do
    GenServer.call(pid, :start)
  end

  def handle_call(:start, caller, machine) do
    Process.send_after(self(), :start, 500)
    {:reply, :ok, {machine, caller}}
  end

  def handle_info(:start, {machine, {caller, _ref}}) do
    with {tape, _, _} = ExMachina.Engine.run(machine) do
      send(caller, {:ok, Tape.to_list(tape)})
    end
    {:noreply, machine}
  end
end
