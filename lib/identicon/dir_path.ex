defmodule Identicon.DirPath do
  use PersistConfig

  alias Identicon.{Drawer, Image, Log}

  @def_dir_path get_env(:def_dir_path)

  @type t :: Path.t()

  @spec new :: t
  def new, do: :dir_path |> get_env(@def_dir_path) |> Path.expand()

  @spec show(t, String.t()) :: :ok
  def show(dir_path, input) do
    file_path = "#{dir_path}/#{input}.png" |> String.replace("/", sep())
    open_with = open_with()
    cmd = to_charlist(~s[#{open_with} "#{file_path}"])

    with %Image{} = image <- Image.new(input),
         binary when is_binary(binary) <- Drawer.render(image),
         :ok <- File.write(file_path, binary),
         pid when is_pid(pid) <- spawn(:os, :cmd, [cmd]) do
      :ok = Log.info(:identicon_shown, {input, dir_path, open_with, __ENV__})
    else
      {:error, reason} ->
        :ok = Log.error(:cannot_show, {input, dir_path, reason, __ENV__})

      non_matched ->
        :ok = Log.error(:non_matched, {input, dir_path, non_matched, __ENV__})
    end
  end

  @spec clear_dir(t, boolean) :: :ok
  def clear_dir(dir_path, dir_reset? \\ true)

  def clear_dir(dir_path, _dir_reset? = true) do
    removed_files_or_dirs = File.rm_rf!(dir_path)
    clear_dir(dir_path, false)
    :ok = Log.info(:dir_cleared, {dir_path, removed_files_or_dirs, __ENV__})
  end

  def clear_dir(dir_path, _no_dir_reset), do: :ok = File.mkdir_p!(dir_path)

  ## Private functions

  @spec open_with :: String.t()
  defp open_with, do: get_env(:open_with)

  @spec sep :: String.t()
  defp sep, do: get_env(:sep)
end
