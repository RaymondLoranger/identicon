defmodule Identicon.TopSup do
  use Application
  use PersistConfig

  alias __MODULE__
  alias Identicon.DirPath.Server

  # @impl Application
  @spec start(Application.start_type(), term) :: {:ok, pid}
  def start(_start_type, :ok = _start_args) do
    [
      # Child spec relying on `use GenServer`...
      {Server, dir_reset?()}
    ]
    |> Supervisor.start_link(name: TopSup, strategy: :one_for_one)
  end

  ## Private functions

  @spec dir_reset? :: boolean
  defp dir_reset?, do: get_env(:dir_reset?, false)
end
