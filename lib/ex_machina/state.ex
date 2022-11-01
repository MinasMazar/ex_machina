defmodule ExMachina.State do
  @moduledoc """
  Turing Machine state.

  ## Example

  iex> ExMachina.State.initial?(0)
  true
  iex> ExMachina.State.final?(0)
  false
  iex> ExMachina.State.initial?(1)
  false
  iex> ExMachina.State.final?(2)
  false
  iex> ExMachina.State.initial?(-1)
  false
  iex> ExMachina.State.final?(-2)
  true
  """
  def initial?(state), do: state == 0
  def final?(state), do: state < 0
end
