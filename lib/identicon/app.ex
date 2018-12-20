defmodule Identicon.App do
  use Application
  use PersistConfig

  alias __MODULE__
  alias __MODULE__.FileReset
  alias Identicon.Server

  @env Application.get_env(@app, :env)
  @identicon_dir Application.get_env(@app, :identicon_dir)

  @error_path Application.get_env(:logger, :error_log)[:path]
  @info_path Application.get_env(:logger, :info_log)[:path]

  @dialyzer {:nowarn_function, start: 2}
  @spec start(Application.start_type(), term) :: {:ok, pid}
  def start(_type, :ok) do
    unless @env == :test do
      [@error_path, @info_path] |> Enum.each(&FileReset.clear_log/1)
      FileReset.clear_dir(@identicon_dir)
    end

    [
      # Child spec relying on use GenServer...
      {Server, :ok}
    ]
    |> Supervisor.start_link(name: App, strategy: :one_for_one)
  end
end
