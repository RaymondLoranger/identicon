defmodule Identicon.Log do
  use File.Only.Logger

  info :dir_cleared, {dir_path, removed_files_or_dirs, env} do
    """
    \nIdenticon directory cleared successfully...
    • Directory:
      #{inspect(dir_path)}
    • Removed: #{phrase(removed_files_or_dirs)}
    • Inside function:
      #{function(env)}
    #{from()}
    """
  end

  info :identicon_shown, {input, dir_path, open_with, env} do
    """
    \nIdenticon in file "#{input}.png" shown successfully...
    • Directory:
      #{inspect(dir_path)}
    • Command: #{open_with}...
    • Inside function:
      #{function(env)}
    #{from()}
    """
  end

  error :cannot_show, {input, dir_path, reason, env} do
    """
    \nCannot show identicon in file "#{input}.png"...
    • Directory:
      #{inspect(dir_path)}
    • Reason:
      #{reason |> :file.format_error() |> inspect()}
    • Inside function:
      #{function(env)}
    #{from()}
    """
  end

  error :non_matched, {input, dir_path, non_matched, env} do
    """
    \nCannot show identicon in file "#{input}.png"...
    • Directory:
      #{inspect(dir_path)}
    • Reason:
      'non-matched value in "with" statement'
    • Non-matched value:
      #{inspect(non_matched)}
    • Inside function:
      #{function(env)}
    #{from()}
    """
  end

  ## Private functions

  @spec phrase([binary]) :: String.t()
  defp phrase(removed_files_or_dirs) when length(removed_files_or_dirs) == 2 do
    "1 file or directory"
  end

  defp phrase(removed_files_or_dirs) do
    "#{length(removed_files_or_dirs) - 1} files or directories"
  end

  @spec function(Macro.Env.t()) :: String.t()
  defp function(%Macro.Env{function: {name, arity}} = env) do
    if name |> to_string() |> String.contains?(" "),
      do: "#{inspect(env.module)}.'#{name}'/#{arity}",
      else: "#{inspect(env.module)}.#{name}/#{arity}"
  end

  defp function(%Macro.Env{function: nil}), do: "'not inside a function'"
end
