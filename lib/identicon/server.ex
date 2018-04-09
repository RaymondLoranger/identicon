defmodule Identicon.Server do
  @moduledoc false

  use GenServer

  alias __MODULE__
  alias Identicon.Drawer

  require Logger

  @spec start_link(term) :: GenServer.on_start()
  def start_link(:ok), do: GenServer.start_link(Server, :ok, name: Server)

  ## Callbacks

  @spec init(term) :: {:ok, :ok}
  def init(:ok), do: {:ok, :ok}

  @spec handle_cast(String.t(), :ok) :: {:noreply, :ok}
  def handle_cast(input, :ok) do
    input
    |> inspect()
    |> (&"Handling cast to depict input #{&1}...").()
    |> Logger.info()

    input
    |> Drawer.depict()
    |> inspect()
    |> (&"Which returned #{&1}.").()
    |> Logger.info()

    {:noreply, :ok}
  end
end
