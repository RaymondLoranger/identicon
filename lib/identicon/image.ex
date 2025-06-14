defmodule Identicon.Image do
  @moduledoc """
  Creates an image struct to be converted into an identicon.

  The image struct contains the fields `bytes`, `color`, `indexes` and
  `squares` representing the properties of an identicon.
  """

  alias __MODULE__
  alias __MODULE__.Builder

  @enforce_keys [:bytes]
  defstruct bytes: [], color: {}, indexes: [], squares: []

  @typedoc "An image struct"
  @type t :: %Image{
          bytes: [byte],
          color: tuple,
          # Indexes of colored squares...
          indexes: [Builder.square_index()],
          # Corners (top-left and bottom-right) of colored squares...
          squares: [tuple]
        }

  @doc """
  Creates an image struct from the given `input`.
  """
  @spec new(String.t()) :: t
  def new(input) do
    input
    |> hash_input()
    |> set_bytes()
    |> set_color()
    |> Builder.derive_indexes()
    |> Builder.derive_squares()
  end

  ## Private functions

  @spec hash_input(String.t()) :: [byte]
  defp hash_input(input) do
    # Always returns 16 bytes...
    :crypto.hash(:md5, input) |> :binary.bin_to_list()
  end

  @spec set_bytes([byte]) :: t
  defp set_bytes(bytes), do: %Image{bytes: bytes}

  @spec set_color(t) :: t
  defp set_color(%Image{bytes: [r, g, b | _tail]} = image),
    do: put_in(image.color, {r, g, b})
end
