# ┌────────────────────────────────────────────────────────────────┐
# │ Based on the course "The Complete Elixir and Phoenix Bootcamp" │
# │ by Stephen Grider.                                             │
# └────────────────────────────────────────────────────────────────┘
defmodule Identicon do
  @moduledoc """
  Opens a PNG file populated with an identicon derived from an input string and
  a dimension (number of squares across or down).

  ##### Based on the course [The Complete Elixir and Phoenix Bootcamp](https://www.udemy.com/the-complete-elixir-and-phoenix-bootcamp-and-tutorial/) by Stephen Grider.
  """

  use PersistConfig

  alias __MODULE__.{DirPath, Log}
  alias __MODULE__.DirPath.Server

  @default_dimension get_env(:default_dimension) |> String.to_integer()
  @valid_dimensions get_env(:valid_dimensions)

  @typedoc "Identicon"
  @type t :: binary

  @doc """
  Opens a PNG file populated with an identicon derived from `input` and
  `dimension`.

  ## Examples

      iex> Identicon.show("fig") # Writes to file "fig 5x5.png" and opens it.
      iex> {:ok, timeout} = :application.get_env(:identicon, :show_timeout)
      iex> Process.sleep(timeout + 1000)
      :ok
  """
  @spec show(String.t(), pos_integer) :: :ok
  def show(input, dimension \\ @default_dimension)

  def show(input, dimension)
      when is_binary(input) and dimension in @valid_dimensions do
    :ok = GenServer.call(Server, {:show, input, dimension}, 9000)
  end

  def show(input, dimension) do
    :ok = Log.error(:invalid_args, {input, dimension, __ENV__})
  end

  @doc """
  Returns the current identicon directory.

  ## Examples

      iex> Identicon.get_dir() |> String.ends_with?("assets/identicons")
      true
  """
  @spec get_dir :: DirPath.t()
  def get_dir do
    GenServer.call(Server, :get_dir)
  end

  @doc """
  Clears the current identicon directory (deletes all PNG files).

  ## Examples

      iex> Identicon.clear_dir()
      :ok
  """
  @spec clear_dir :: :ok
  def clear_dir do
    :ok = GenServer.cast(Server, :clear_dir)
  end

  @doc """
  Changes the current identicon directory to `dir_path` (should exist).

  ## Examples

      iex> Identicon.change_dir("C:/Users/Ray/Desktop")
      iex> Identicon.get_dir()
      "c:/Users/Ray/Desktop"
  """
  @spec change_dir(DirPath.t()) :: :ok
  def change_dir(dir_path) do
    :ok = GenServer.cast(Server, {:dir_path, dir_path})
  end
end
