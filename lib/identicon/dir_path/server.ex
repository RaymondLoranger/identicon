defmodule Identicon.DirPath.Server do
  use GenServer

  alias __MODULE__
  alias Identicon.DirPath

  @type from :: GenServer.from()
  @type handle_call :: {:reply, reply :: term, state :: DirPath.t()}
  @type handle_info :: {:noreply, state :: DirPath.t()}
  @type init :: {:ok, state :: DirPath.t()}
  @type message :: tuple
  @type on_start :: GenServer.on_start()
  @type request :: atom | tuple

  @spec start_link(term) :: on_start
  def start_link(dir_reset?) do
    GenServer.start_link(Server, dir_reset?, name: Server)
  end

  ## Callbacks

  @spec init(term) :: init
  def init(dir_reset?) do
    self() |> send({:clear_dir, dir_reset?})
    {:ok, DirPath.new()}
  end

  @spec handle_info(message, DirPath.t()) :: handle_info
  def handle_info({:clear_dir, dir_reset?}, dir_path) do
    :ok = DirPath.clear_dir(dir_path, dir_reset?)
    {:noreply, dir_path}
  end

  def handle_info(_message, state) do
    {:noreply, state}
  end

  @spec handle_call(request, from, DirPath.t()) :: handle_call
  def handle_call(:clear_dir, _from, dir_path) do
    :ok = DirPath.clear_dir(dir_path)
    {:reply, :ok, dir_path}
  end

  def handle_call({:show, input}, _from, dir_path) do
    :ok = DirPath.show(dir_path, input)
    {:reply, :ok, dir_path}
  end
end
