defmodule Identicon.DirPath.Server do
  @moduledoc """
  A server process that holds the identicon directory path as its state.
  """

  use GenServer

  alias __MODULE__
  alias Identicon.DirPath

  @doc """
  Spawns an identicon server process registered under the module name.
  """
  @spec start_link(term) :: GenServer.on_start()
  def start_link(_init_arg = :ok) do
    GenServer.start_link(Server, :ok, name: Server)
  end

  ## Callbacks

  @spec init(term) :: {:ok, state :: DirPath.t()}
  def init(_init_arg = :ok) do
    {:ok, DirPath.new()}
  end

  @spec handle_info(msg :: term, state :: DirPath.t()) ::
          {:noreply, state :: DirPath.t()}
  def handle_info(_message, dir_path), do: {:noreply, dir_path}

  @spec handle_call(request :: atom, GenServer.from(), state :: DirPath.t()) ::
          {:reply, reply :: DirPath.t(), state :: DirPath.t()}
  def handle_call(:get_dir, _from, dir_path) do
    {:reply, dir_path, dir_path}
  end

  @spec handle_cast(request :: tuple | atom, state :: DirPath.t()) ::
          {:noreply, state :: DirPath.t()}
  def handle_cast({:dir_path, new_dir_path}, dir_path) do
    {:noreply, DirPath.change_dir(dir_path, new_dir_path)}
  end

  def handle_cast({:show, input}, dir_path) do
    :ok = DirPath.show(dir_path, input)
    {:noreply, dir_path}
  end

  def handle_cast(:clear_dir, dir_path) do
    :ok = DirPath.clear_dir(dir_path)
    {:noreply, dir_path}
  end
end
