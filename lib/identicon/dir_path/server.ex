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
    self() |> send(:create_dir)
    {:ok, DirPath.new()}
  end

  @spec handle_info(msg :: atom, state :: DirPath.t()) ::
          {:noreply, state :: DirPath.t()}
  def handle_info(:create_dir, dir_path) do
    :ok = DirPath.create_dir(dir_path)
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
