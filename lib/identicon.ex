defmodule Identicon do
  use PersistConfig

  @course_ref Application.get_env(@app, :course_ref)

  @moduledoc """
  Generates, writes and displays an identicon for a given input string.

  ##### #{@course_ref}
  """

  alias __MODULE__.Server

  @doc """
  Generates, writes and displays an identicon "representing" a given `input`.

  ## Examples

      Identicon.iconize("banana") # Writes file "banana.png" and displays it.
  """
  @spec iconize(String.t()) :: :ok
  def iconize(input) when is_binary(input), do: GenServer.cast(Server, input)
end
