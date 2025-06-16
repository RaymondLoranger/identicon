defmodule Identicon.Log do
  use File.Only.Logger

  require Logger

  info :files_found, {dir, files, env} do
    """
    \nFound #{phrase(files)} to be deleted...
    • Directory: #{inspect(dir) |> maybe_break(13)}
    • Files: #{for file <- files do
      "\n  #{String.replace_leading(file, dir, "...") |> inspect()}"
    end}
    #{from(env, __MODULE__)}\
    """
  end

  info :dir_changed, {from, to, env} do
    """
    \nIdenticon directory changed...
    • From: #{inspect(from) |> maybe_break(8)}
    • To: #{inspect(to) |> maybe_break(6)}
    #{from(env, __MODULE__)}\
    """
  end

  info :file_deleted, {base, dir, env} do
    """
    \nFile "#{base}" successfully deleted...
    • Directory: #{inspect(dir) |> maybe_break(13)}
    #{from(env, __MODULE__)}\
    """
  end

  def error(:file_not_deleted, {base, dir, reason, env}) do
    Logger.error("""
    \nFile "#{base}" not deleted...
    • Directory: #{inspect(dir) |> maybe_break(13)}
    • Reason: #{"'#{:file.format_error(reason)}'" |> maybe_break(10)}
    #{from(env, __MODULE__)}\
    """)
  end

  info :identicon_shown, {input, dir_path, open_with, timeout, env} do
    """
    \nIdenticon in file "#{input}.png" shown successfully for #{timeout} ms...
    • Directory: #{inspect(dir_path) |> maybe_break(13)}
    • Command: #{open_with}...
    #{from(env, __MODULE__)}\
    """
  end

  def error(:cannot_write, {input, dir_path, reason, env}) do
    Logger.error("""
    \nCannot write identicon into file "#{input}.png"...
    • Directory: #{inspect(dir_path) |> maybe_break(13)}
    • Reason: #{"'#{:file.format_error(reason)}'" |> maybe_break(10)}
    #{from(env, __MODULE__)}\
    """)
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
  defp phrase(files) when length(files) == 1 do
    "1 file"
  end

  defp phrase(files) do
    "#{length(files)} files"
  end
end
