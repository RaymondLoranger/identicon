# ┌────────────────────────────────────────────────────────────────┐
# │ Based on the course "The Complete Elixir and Phoenix Bootcamp" │
# │ by Stephen Grider.                                             │
# └────────────────────────────────────────────────────────────────┘
defmodule Identicon do
  @moduledoc """
  Opens a PNG file populated with an identicon derived from an input string.

  ##### Based on the course [The Complete Elixir and Phoenix Bootcamp](https://www.udemy.com/the-complete-elixir-and-phoenix-bootcamp-and-tutorial/) by Stephen Grider.
  """

  alias __MODULE__.DirPath.Server

  @typedoc "Identicon"
  @type t :: binary

  @doc """
  Opens a PNG file populated with an identicon derived from `input`.

  ## Examples

      iex> Identicon.show("guava") # Writes to and opens file "guava.png".
      :ok
  """
  @spec show(String.t()) :: :ok
  def show(input) when is_binary(input) do
    :ok = GenServer.call(Server, {:show, input})
  end

  @doc """
  Clears the configured identicon directory.

  ## Examples

      iex> Identicon.clear_dir()
      :ok
  """
  @spec clear_dir :: :ok
  def clear_dir do
    :ok = GenServer.call(Server, :clear_dir)
  end
end
