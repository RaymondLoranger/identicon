defmodule Identicon.Image do
  alias __MODULE__
  alias __MODULE__.Builder

  @enforce_keys [:bytes]
  defstruct bytes: [], color: {}, indexes: [], squares: []

  @type t :: %Image{
          bytes: [byte],
          color: tuple,
          # Indexes of colored squares...
          indexes: [Builder.square_index()],
          # Corners (top-left and bottom-right) of colored squares...
          squares: [tuple]
        }

  @spec new(String.t()) :: t
  def new(input) do
    input
    |> hash_input()
    |> init()
    |> pick_color()
    |> Builder.derive_indexes()
    |> Builder.derive_squares()
  end

  ## Private functions

  @spec init([byte]) :: t
  defp init(bytes), do: %Image{bytes: bytes}

  @spec hash_input(String.t()) :: [byte]
  defp hash_input(input) do
    # Always returns 16 bytes...
    :crypto.hash(:md5, input) |> :binary.bin_to_list()
  end

  @spec pick_color(t) :: t
  defp pick_color(%Image{bytes: [r, g, b | _tail]} = image),
    do: put_in(image.color, {r, g, b})
end
