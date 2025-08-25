# ┌────────────────────────────────────────────────────────────────┐
# │ Based on the course "The Complete Elixir and Phoenix Bootcamp" │
# │ by Stephen Grider.                                             │
# └────────────────────────────────────────────────────────────────┘
defmodule Identicon do
  @moduledoc """
  Opens a PNG file populated with an identicon derived from an input string,
  a dimension and a size.

  ##### Based on the course [The Complete Elixir and Phoenix Bootcamp](https://www.udemy.com/the-complete-elixir-and-phoenix-bootcamp-and-tutorial/) by Stephen Grider.
  """

  use PersistConfig

  alias __MODULE__.{Drawer, Image, Log}

  @default_dim get_env(:default_dimension) |> String.to_integer()
  @default_switches get_env(:default_switches)
  @default_size @default_switches.size
  @default_duration @default_switches.duration
  @default_bell? @default_switches.bell
  @directory get_env(:directory)

  @typedoc "Identicon"
  @type t :: binary

  @doc """
  Opens a PNG file populated with an identicon derived from `input`, `dim` and
  `size`.

  ## Examples

      Identicon.show("fig") # Writes to file "fig 250px 5x5.png" and opens it.
  """
  @dialyzer {:no_return, [show: 1, show: 2, show: 3, show: 4, show: 5]}
  @spec show(String.t(), pos_integer, pos_integer, pos_integer, boolean) :: :ok
  def show(
        input,
        dim \\ @default_dim,
        size \\ @default_size,
        duration \\ @default_duration,
        bell? \\ @default_bell?
      ) do
    base_name = "#{input} #{size}px #{dim}x#{dim}.png"
    file_path = String.replace("#{@directory}/#{base_name}", "/", separator())
    open_with = open_with()
    close_cmd = close_cmd()
    identicon = Image.new(input, dim, size) |> Drawer.render()

    with :ok <- File.write(file_path, identicon) do
      IO.write(if bell?, do: "\a", else: "")
      _open_pid = spawn_link(fn -> open(open_with, file_path) end)
      closetask = Task.async(fn -> close(close_cmd, duration) end)
      await_max = :timer.seconds(duration + 1)
      _charlist = Task.await(closetask, await_max)
      args = {base_name, @directory, open_with, duration, __ENV__}
      :ok = Log.info(:identicon_shown, args)
    else
      {:error, reason} ->
        :ok = Log.error(:cannot_write, {base_name, @directory, reason, __ENV__})
    end
  end

  ## Private functions

  @spec open_with :: binary
  defp open_with, do: get_env(:open_with)

  @spec separator :: binary
  defp separator, do: get_env(:separator)

  @spec close_cmd :: charlist
  defp close_cmd, do: get_env(:close_cmd)

  @dialyzer {:no_unused, [open: 2]}
  @spec open(binary, binary) :: charlist
  defp open(open_with, file_path) do
    :os.cmd(~c[#{open_with} "#{file_path}"])
  end

  @dialyzer {:no_unused, [close: 2]}
  @spec close(charlist, pos_integer) :: charlist
  defp close(close_cmd, duration) do
    :timer.seconds(duration) |> Process.sleep()
    :os.cmd(close_cmd)
  end
end
