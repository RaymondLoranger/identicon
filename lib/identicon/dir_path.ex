defmodule Identicon.DirPath do
  @moduledoc """
  Clears or changes the identicon directory (configured or ad hoc).
  Also populates a PNG file with an identicon and opens that file.
  """

  use PersistConfig

  alias Identicon.{Drawer, Image, Log}

  @default_dir_path get_env(:default_dir_path)
  @timeout get_env(:show_timeout)

  @typedoc "Identicon directory path"
  @type t :: Path.t()

  @doc """
  Returns the absolute path of the configured identicon directory.
  """
  @spec new :: t
  def new, do: get_env(:dir_path, @default_dir_path) |> Path.expand()

  @doc """
  Returns the absolute path of `dir_path`.
  """
  @spec new(t) :: t
  def new(dir_path), do: Path.expand(dir_path)

  @doc """
  Populates a PNG file with an identicon and opens that file.
  """
  @spec show(t, String.t()) :: :ok
  def show(dir_path, input) do
    file_path = "#{dir_path}/#{input}.png" |> String.replace("/", sep())
    open_with = open_with()
    close_cmd = close_cmd()
    identicon = Image.new(input) |> Drawer.render()

    with :ok <- File.write(file_path, identicon),
         _pid = spawn(fn -> open(open_with, file_path) end),
         _pid = spawn(fn -> close(close_cmd, @timeout) end) do
      :ok = Log.info(:identicon_shown, {input, dir_path, open_with, __ENV__})
    else
      {:error, reason} ->
        :ok = Log.error(:cannot_write, {input, dir_path, reason, __ENV__})
    end
  end

  @doc """
  Changes the identicon directory from `from_dir` to `to_dir` (should exist).
  """
  @spec change_dir(t, t) :: t
  def change_dir(from_dir, to_dir) do
    new_dir = new(to_dir)
    :ok = Log.info(:dir_changed, {from_dir, new_dir, __ENV__})
    new_dir
  end

  @doc """
  Deletes the PNG files of directory `dir_path` and its subdirectories.
  """
  @spec clear_dir(t) :: :ok
  def clear_dir(dir_path) do
    glob = Path.absname("**/*.png", dir_path)
    files = Path.wildcard(glob)
    :ok = Log.info(:files_found, {dir_path, files, __ENV__})

    Enum.each(files, fn file ->
      {base, dir} = {Path.basename(file), Path.dirname(file)}

      case File.rm(file) do
        :ok ->
          :ok = Log.info(:file_deleted, {base, dir, __ENV__})

        {:error, reason} ->
          :ok = Log.error(:file_not_deleted, {base, dir, reason, __ENV__})
      end
    end)
  end

  ## Private functions

  @spec open_with :: binary
  defp open_with, do: get_env(:open_with)

  @spec sep :: binary
  defp sep, do: get_env(:sep)

  @spec close_cmd :: charlist
  defp close_cmd, do: get_env(:close_cmd)

  @spec open(binary, binary) :: charlist
  defp open(open_with, file_path) do
    :os.cmd(~c[#{open_with} "#{file_path}"])
  end

  @spec close(charlist, pos_integer) :: charlist
  defp close(close_cmd, timeout) do
    Process.sleep(timeout)
    :os.cmd(close_cmd)
  end
end
