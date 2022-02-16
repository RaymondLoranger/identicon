defmodule Identicon.DirPath do
  @moduledoc """
  Creates or clears the configured identicon directory.
  Also populates a PNG file with an identicon and opens that file.
  """

  use PersistConfig

  alias Identicon.{Drawer, Image, Log}

  @default_dir_path get_env(:default_dir_path)

  @typedoc "Identicon directory path"
  @type t :: Path.t()

  @doc """
  Returns the absolute path of the configured identicon directory.
  """
  @spec new :: t
  def new, do: get_env(:dir_path, @default_dir_path) |> Path.expand()

  @doc """
  Populates a PNG file with an identicon and opens that file.
  """
  @spec show(t, String.t()) :: :ok
  def show(dir_path, input) do
    file_path = "#{dir_path}/#{input}.png" |> String.replace("/", sep())
    open_with = open_with()
    cmd = to_charlist(~s[#{open_with} "#{file_path}"])
    binary = Image.new(input) |> Drawer.render()

    with :ok <- File.write(file_path, binary),
         _pid = spawn(:os, :cmd, [cmd]) do
      :ok = Log.info(:identicon_shown, {input, dir_path, open_with, __ENV__})
    else
      {:error, reason} ->
        :ok = Log.error(:cannot_write, {input, dir_path, reason, __ENV__})
    end
  end

  @doc """
  Creates directory `dir_path`.
  """
  @spec create_dir(t) :: :ok
  def create_dir(dir_path) do
    :ok = File.mkdir_p(dir_path)
  end

  @doc """
  Removes the files and subdirectories of directory `dir_path`.
  """
  @spec clear_dir(t) :: :ok
  def clear_dir(dir_path) do
    {:ok, removed_files_and_dirs} = File.rm_rf(dir_path)
    :ok = create_dir(dir_path)
    :ok = Log.info(:dir_cleared, {dir_path, removed_files_and_dirs, __ENV__})
  end

  ## Private functions

  @spec open_with :: String.t()
  defp open_with, do: get_env(:open_with)

  @spec sep :: String.t()
  defp sep, do: get_env(:sep)
end
