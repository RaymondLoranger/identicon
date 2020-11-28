defmodule Identicon do
  @moduledoc """
  Populates and shows a PNG file representing an input string.

  ##### Based on the course [The Complete Elixir and Phoenix Bootcamp](https://www.udemy.com/the-complete-elixir-and-phoenix-bootcamp-and-tutorial/) by Stephen Grider.
  """

  alias __MODULE__.DirPath.Server

  @doc """
  Populates and shows a PNG file representing a given `input` string.

  ## Examples

      iex> Identicon.show("fig") # Writes to and opens file "fig.png".
      :ok
  """
  @spec show(String.t()) :: :ok
  def show(input) when is_binary(input) do
    :ok = GenServer.call(Server, {:show, input})
  end

  @spec clear_dir :: :ok
  def clear_dir do
    :ok = GenServer.call(Server, :clear_dir)
  end
end
