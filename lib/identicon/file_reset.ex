defmodule Identicon.FileReset do
  import IO.ANSI, only: [format: 1]

  @spec clear_log(Path.t()) :: :ok
  def clear_log(log_path) do
    log_path = Path.expand(log_path)
    dir_path = Path.dirname(log_path)
    create_dir(dir_path)

    case File.write(log_path, "") do
      :ok -> :ok
      {:error, reason} -> error(reason, "Couldn't clear log file", log_path)
    end
  end

  @spec clear_dir(Path.t()) :: :ok
  def clear_dir(dir_path) do
    dir_path = Path.expand(dir_path)

    case File.rm_rf(dir_path) do
      {:ok, _files_and_directories} -> :ok
      {:error, reason, dir?} -> error(reason, "Couldn't delete", dir?)
    end

    create_dir(dir_path)
  end

  ## Private functions

  @spec create_dir(Path.t()) :: :ok
  defp create_dir(dir_path) do
    case File.mkdir_p(dir_path) do
      :ok -> :ok
      {:error, reason} -> error(reason, "Couldn't create directory", dir_path)
    end
  end

  @spec error(File.posix(), String.t(), Path.t()) :: :ok
  defp error(reason, msg, path) do
    [:light_red_background, :light_white, "#{msg}:"] |> format() |> IO.puts()
    [:light_yellow, "#{inspect(path)}"] |> format() |> IO.puts()
    [:light_yellow, "=> #{:file.format_error(reason)}"] |> format() |> IO.puts()
  end
end
