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

  alias __MODULE__.{Drawer, Help, Image, Log}

  @default_dimension get_env(:default_dimension)
  @default_switches get_env(:default_switches)
  @default_bell? @default_switches.bell
  @default_duration @default_switches.duration
  @default_size @default_switches.size
  @directory get_env(:directory)
  @valid_dimensions get_env(:valid_dimensions)
  @valid_durations get_env(:valid_durations)
  @valid_sizes get_env(:valid_sizes)

  @typedoc "Identicon"
  @type t :: binary

  defguardp valid?(input, dimension, size, duration)
            when is_binary(input) and dimension in @valid_dimensions and
                   size in @valid_sizes and duration in @valid_durations

  @doc """
  Opens a PNG file populated with an identicon derived from `input` and
  `options`.

  ## Options

    * `:dimension` - number of squares across and down in the identicon.
      Can be `5` (default), `6`, `7`, `8`, `9` or `10`.

    * `:size` - width and height of the identicon in pixels.
      Can be `250` (default), `300` or `350`.

    * `:duration` - number of seconds to display the identicon.
      Can be `3` (default), `4`, `5`, `6`, `7`, `8` or `9`.

    * `:bell` - whether to ring the bell. Defaults to `false`.

  ## Examples

      # Creates file "olive 250px 5x5.png" and opens it for 3 seconds.
      Identicon.display("olive")

      # Creates file "grape 300px 7x7.png" and opens it for 5 seconds.
      Identicon.display("grape", dimension: 7, size: 300, duration: 5)
  """
  @spec display(String.t(), keyword) :: :ok
  def display(input, options \\ []) do
    dimension = Keyword.get(options, :dimension, @default_dimension)
    size = Keyword.get(options, :size, @default_size)
    duration = Keyword.get(options, :duration, @default_duration)
    bell? = Keyword.get(options, :bell, @default_bell?)
    :ok = _display(input, dimension, size, duration, bell?)
  end

  ## Private functions

  @spec _display(String.t(), pos_integer, pos_integer, pos_integer, any) :: :ok
  defp _display(input, dimension, size, duration, bell?)
       when valid?(input, dimension, size, duration) do
    base_name = "#{input} #{size}px #{dimension}x#{dimension}.png"
    file_path = String.replace("#{@directory}/#{base_name}", "/", separator())
    open_with = open_with()
    close_cmd = close_cmd()
    identicon = Image.new(input, dimension, size) |> Drawer.render()

    with :ok <- File.write(file_path, identicon) do
      info = self() |> Process.info()
      iex? = info[:dictionary][:iex_server]
      IO.write(if !iex? && bell?, do: "\a", else: "")
      _open_pid = spawn_link(fn -> open(open_with, file_path) end)
      closetask = Task.async(fn -> close(close_cmd, duration) end)
      await_max = :timer.seconds(duration + 1)
      _charlist = Task.await(closetask, await_max)
      args = {base_name, @directory, open_with, duration, __ENV__}
      :ok = Log.info(:identicon_displayed, args)
    else
      {:error, reason} ->
        :ok = Log.error(:cannot_write, {base_name, @directory, reason, __ENV__})
    end
  end

  defp _display(_input, _dimension, _size, _duration, _bell?) do
    :ok = Help.print_help()
  end

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
