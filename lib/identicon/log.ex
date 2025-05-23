defmodule Identicon.Log do
  use File.Only.Logger

  info :dir_cleared, {dir, files_and_dirs, env} do
    """
    \nIdenticon directory cleared successfully...
    • Directory: #{inspect(dir) |> maybe_break(13)}
    • Removed: #{phrase(files_and_dirs) |> maybe_break(11)}
    • Files and/or subdirectories: #{for file <- files_and_dirs, file != dir do
      "\n  #{String.replace(file, dir, "...") |> inspect()}"
    end}
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

  debug :assert_banana_color, {color, env} do
    """
    \nAsserting 'banana' is an image struct having field color...
    • Color: #{inspect(color) |> maybe_break(9)}
    #{from(env, __MODULE__)}\
    """
  end

  debug :assert_banana_indexes, {indexes, env} do
    """
    \nAsserting 'banana' is an image struct having field indexes...
    • Indexes: #{inspect(indexes) |> maybe_break(11)}
    #{from(env, __MODULE__)}\
    """
  end

  debug :assert_banana_struct, {image, env} do
    """
    \nAsserting 'banana' is an image struct...
    • Image: #{inspect(image) |> maybe_break(9)}
    #{from(env, __MODULE__)}\
    """
  end

  ## Private functions

  @spec phrase([binary]) :: String.t()
  defp phrase(files_and_dirs) when length(files_and_dirs) in [0, 1] do
    "0 files and/or subdirectories"
  end

  defp phrase(files_and_dirs) when length(files_and_dirs) == 2 do
    "1 file and/or subdirectory"
  end

  defp phrase(files_and_dirs) do
    "#{length(files_and_dirs) - 1} files and/or subdirectories"
  end
end
