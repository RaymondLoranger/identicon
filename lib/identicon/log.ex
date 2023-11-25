defmodule Identicon.Log do
  use File.Only.Logger

  info :dir_cleared, {dir_path, removed_files_and_dirs, env} do
    """
    \nIdenticon directory cleared successfully...
    • Directory: #{inspect(dir_path) |> maybe_break(13)}
    • Removed: #{phrase(removed_files_and_dirs) |> maybe_break(11)}
    #{from(env, __MODULE__)}\
    """
  end

  info :identicon_shown, {input, dir_path, open_with, env} do
    """
    \nIdenticon in file "#{input}.png" shown successfully...
    • Directory: #{inspect(dir_path) |> maybe_break(13)}
    • Command: #{open_with}...
    #{from(env, __MODULE__)}\
    """
  end

  error :cannot_write, {input, dir_path, reason, env} do
    """
    \nCannot write identicon into file "#{input}.png"...
    • Directory: #{inspect(dir_path) |> maybe_break(13)}
    • Reason: #{:file.format_error(reason) |> inspect() |> maybe_break(10)}
    #{from(env, __MODULE__)}\
    """
  end

  debug :image_test_1, {color, env} do
    """
    \nCreating 'banana' image having field color...
    • Color: #{inspect(color) |> maybe_break(9)}
    #{from(env, __MODULE__)}\
    """
  end

  debug :image_test_2, {indexes, env} do
    """
    \nCreating 'banana' image having field indexes...
    • Indexes: #{inspect(indexes) |> maybe_break(11)}
    #{from(env, __MODULE__)}\
    """
  end

  debug :image_test_3, {image, env} do
    """
    \nCreating 'banana' image...
    • Image: #{inspect(image) |> maybe_break(9)}
    #{from(env, __MODULE__)}\
    """
  end

  ## Private functions

  @spec phrase([binary]) :: String.t()
  defp phrase(files_and_dirs) when length(files_and_dirs) in [0, 1] do
    "0 files or directories"
  end

  defp phrase(files_and_dirs) when length(files_and_dirs) == 2 do
    "1 file or directory"
  end

  defp phrase(files_and_dirs) do
    "#{length(files_and_dirs) - 1} files or directories"
  end
end
