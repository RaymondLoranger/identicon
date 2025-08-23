# ┌────────────────────────────────────────────────────────────────┐
# │ Based on the course "The Complete Elixir and Phoenix Bootcamp" │
# │ by Stephen Grider.                                             │
# └────────────────────────────────────────────────────────────────┘
defmodule Identicon do
  @moduledoc """
  Opens a PNG file populated with an identicon derived from an input string.

  ##### Based on the course [The Complete Elixir and Phoenix Bootcamp](https://www.udemy.com/the-complete-elixir-and-phoenix-bootcamp-and-tutorial/) by Stephen Grider.
  """

  use PersistConfig

  alias __MODULE__.{Drawer, Image, Log}

  @typedoc "Identicon"
  @type t :: binary

  @doc """
  Opens a PNG file populated with an identicon derived from `input`,
  `dimension` and `size`.

  ## Examples

      iex> Identicon.show("fig") # Writes to file "fig 5x5.png" and opens it.
      :ok
  """
  # @spec show(String.t(), pos_integer, keyword) :: :ok
  def show(input, dim, bell?, size, duration) do
    base_name = "#{input} #{dim}x#{dim}.png"
    directory = directory()
    file_path = String.replace("#{directory}/#{base_name}", "/", separator())
    open_with = open_with()
    close_cmd = close_cmd()
    identicon = Image.new(input, dim, size, duration) |> Drawer.render()

    with :ok <- File.write(file_path, identicon) do
      IO.write(if bell?, do: "\a", else: "")
      spawn_link(fn -> open(open_with, file_path) end)

      Task.async(fn -> close(close_cmd, duration) end)
      |> Task.await(duration + 1000)

      args = {base_name, directory, open_with, duration, __ENV__}
      :ok = Log.info(:identicon_shown, args)
    else
      {:error, reason} ->
        :ok = Log.error(:cannot_write, {base_name, directory, reason, __ENV__})
    end
  end

  def show(input, dimension, _options) do
    :ok = Log.error(:invalid_args, {input, dimension, __ENV__})
  end

  ## Private functions

  @spec open_with :: binary
  defp open_with, do: get_env(:open_with)

  @spec separator :: binary
  defp separator, do: get_env(:separator)

  @spec close_cmd :: charlist
  defp close_cmd, do: get_env(:close_cmd)

  # @spec show_timeout :: pos_integer
  # defp show_timeout, do: get_env(:show_timeout)

  @spec open(binary, binary) :: charlist
  defp open(open_with, file_path) do
    :os.cmd(~c[#{open_with} "#{file_path}"])
  end

  @spec close(charlist, pos_integer) :: charlist
  defp close(close_cmd, duration) do
    Process.sleep(duration)
    :os.cmd(close_cmd)
  end

  def directory, do: get_env(:directory)
end
