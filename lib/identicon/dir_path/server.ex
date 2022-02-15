defmodule Identicon.DirPath.Server do
  @moduledoc """
  A server process that holds the identicon directory path as its state.
  """

  use GenServer

  alias __MODULE__
  alias Identicon.DirPath

  @doc """
  Spawns an identicon directory path server process.
  """
  @spec start_link(term) :: GenServer.on_start()
  def start_link(dir_reset?) do
    GenServer.start_link(Server, dir_reset?, name: Server)
  end

  ## Callbacks

  @spec init(term) :: {:ok, state :: DirPath.t()}
  def init(dir_reset?) do
    self() |> send({:clear_dir, dir_reset?})
    {:ok, DirPath.new()}
  end

  @spec handle_info(msg :: tuple, state :: DirPath.t()) ::
          {:noreply, state :: DirPath.t()}
  def handle_info({:clear_dir, dir_reset?}, dir_path) do
    :ok = DirPath.clear_dir(dir_path, dir_reset?)
    {:noreply, dir_path}
  end

  def handle_info(_message, dir_path), do: {:noreply, dir_path}

  @spec handle_call(request :: atom | tuple, GenServer.from(), DirPath.t()) ::
          {:reply, reply :: term, state :: DirPath.t()}
  def handle_call(:clear_dir, _from, dir_path) do
    :ok = DirPath.clear_dir(dir_path)
    {:reply, :ok, dir_path}
  end

  def handle_call({:show, input}, _from, dir_path) do
    :ok = DirPath.show(dir_path, input)
    {:reply, :ok, dir_path}
  end
end
