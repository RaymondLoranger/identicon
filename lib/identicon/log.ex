defmodule Identicon.Log do
  use File.Only.Logger

  require Logger

  info :identicon_shown, {base_name, directory, open_with, duration, env} do
    """
    \nIdenticon in file "#{base_name}" shown successfully for #{duration} s...
    • Directory: #{inspect(directory) |> maybe_break(13)}
    • Command: #{open_with}...
    #{from(env, __MODULE__)}\
    """
  end

  def error(:cannot_write, {base_name, directory, reason, env}) do
    Logger.error("""
    \nCannot write identicon into file "#{base_name}"...
    • Directory: #{inspect(directory) |> maybe_break(13)}
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
end
