defmodule Identicon.TopSup do
  use Application

  alias __MODULE__
  alias Identicon.DirPath.Server

  @spec start(Application.start_type(), term) :: {:ok, pid}
  def start(_start_type, _start_args = :ok) do
    [
      # Child spec relying on `use GenServer`...
      {Server, :ok}
    ]
    |> Supervisor.start_link(name: TopSup, strategy: :one_for_one)
  end
end
