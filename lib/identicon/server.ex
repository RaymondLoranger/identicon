defmodule Identicon.Server do
  use GenServer

  alias __MODULE__
  alias Identicon.Drawer

  require Logger

  @spec start_link(term) :: GenServer.on_start()
  def start_link(:ok), do: GenServer.start_link(Server, :ok, name: Server)

  ## Callbacks

  @spec init(term) :: {:ok, term}
  def init(:ok), do: {:ok, :ok}

  @spec handle_cast(String.t(), term) :: {:noreply, term}
  def handle_cast(input, :ok) do
    case Drawer.depict(input) do
      :ok -> log(input, :ok)
      {:error, reason} -> log(input, :file.format_error(reason))
    end

    {:noreply, :ok}
  end

  ## Private functions

  @spec phrase(String.t(), term) :: String.t()
  defp phrase(input, result),
    do: "`handle_cast` to depict #{inspect(input)} => #{inspect(result)}"

  @spec log(String.t(), term) :: :ok | {:error, term}
  defp log(input, :ok), do: input |> phrase(:ok) |> Logger.info()
  defp log(input, charlist), do: input |> phrase(charlist) |> Logger.error()
end
