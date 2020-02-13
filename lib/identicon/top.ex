defmodule Identicon.Top do
  @moduledoc false

  use Application
  use PersistConfig

  alias __MODULE__
  alias __MODULE__.FileReset
  alias Identicon.Server

  @identicon_dir Application.get_env(@app, :identicon_dir)

  # @dialyzer {:nowarn_function, start: 2}
  @spec start(Application.start_type(), term) :: {:ok, pid}
  def start(_type, :ok) do
    if reset?(), do: FileReset.clear_dir(@identicon_dir)

    [
      # Child spec relying on use GenServer...
      {Server, :ok}
    ]
    |> Supervisor.start_link(name: Top, strategy: :one_for_one)
  end

  ## Private functions

  @spec reset? :: boolean
  defp reset?, do: Application.get_env(@app, :reset?)
end
