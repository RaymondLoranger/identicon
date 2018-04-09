defmodule Identicon do
  use PersistConfig

  @book_ref Application.get_env(@app, :book_ref)

  @moduledoc """
  Generates, writes and displays an identicon for a given input string.

  ##### #{@book_ref}
  """

  alias __MODULE__.Server

  @doc """
  Generates, writes and displays an identicon "depicting" a given `input`.

  ## Examples

      Identicon.depict("banana") # writes file "banana.png" and displays it
  """
  @spec depict(String.t()) :: :ok
  def depict(input), do: GenServer.cast(Server, input)
end
