defmodule Identicon.Log do
  use File.Only.Logger

  info :dir_cleared, {dir_path, removed_files_or_dirs, env} do
    """
    \nIdenticon directory cleared successfully...
    • Inside function:
      #{fun(env)}
    • Directory:
      #{inspect(dir_path)}
    • Removed: #{phrase(removed_files_or_dirs)}
    #{from()}
    """
  end

  info :identicon_shown, {input, dir_path, open_with, env} do
    """
    \nIdenticon in file "#{input}.png" shown successfully...
    • Inside function:
      #{fun(env)}
    • Directory:
      #{inspect(dir_path)}
    • Command: #{open_with}...
    #{from()}
    """
  end

  error :cannot_write, {input, dir_path, reason, env} do
    """
    \nCannot write identicon into file "#{input}.png"...
    • Inside function:
      #{fun(env)}
    • Directory:
      #{inspect(dir_path)}
    • Reason:
      #{:file.format_error(reason) |> inspect()}
    #{from()}
    """
  end

  ## Private functions

  @spec phrase([binary]) :: String.t()
  defp phrase(files_or_dirs) when length(files_or_dirs) in [0, 1] do
    "0 files or directories"
  end

  defp phrase(files_or_dirs) when length(files_or_dirs) == 2 do
    "1 file or directory"
  end

  defp phrase(files_or_dirs) do
    "#{length(files_or_dirs) - 1} files or directories"
  end
end
