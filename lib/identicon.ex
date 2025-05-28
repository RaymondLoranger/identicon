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
      iex> {:ok, timeout} = :application.get_env(:identicon, :show_timeout)
      iex> Process.sleep(timeout)
      :ok
  """
  @spec show(String.t()) :: :ok
  def show(input) when is_binary(input) do
    :ok = GenServer.cast(Server, {:show, input})
  end

  @doc """
  Returns the current identicon directory.

  ## Examples

      iex> Identicon.get_dir() |> String.ends_with?("assets/identicons")
      true
  """
  @spec get_dir :: :ok
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
  def change_dir(dir_path) do
    :ok = GenServer.cast(Server, {:dir_path, dir_path})
  end
end
