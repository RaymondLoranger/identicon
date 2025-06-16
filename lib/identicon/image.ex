defmodule Identicon.Image do
  @moduledoc """
  Creates an image struct to be converted into an identicon.

  The image struct contains the fields `input`, `dimension`, `chunk_size`,
  `square_size`, `bytes_length`, `bytes`, `color`, `indexes` and `squares`
  representing the properties of an identicon image.
  """

  use PersistConfig

  alias __MODULE__
  alias __MODULE__.Builder

  # Identicon side length in pixels...
  @side_length get_env(:side_length)

  @enforce_keys [:input, :dimension]
  defstruct input: "",
            dimension: 5,
            chunk_size: 3,
            square_size: round(250 / 5),
            bytes_length: 3 * 5,
            bytes: [],
            color: {},
            indexes: [],
            squares: []

  @typedoc "An image struct"
  @type t :: %Image{
          # Input string to be hashed...
          input: String.t(),
          # Number of squares down and across...
          dimension: pos_integer,
          # Number of digest bytes per chunk...
          chunk_size: pos_integer,
          # Size of each square in pixels...
          square_size: pos_integer,
          bytes_length: pos_integer,
          # Digest bytes...
          bytes: [byte],
          color: tuple,
          # Indexes of colored squares...
          indexes: [Builder.square_index()],
          # Corners (top-left and bottom-right) of colored squares...
          squares: [tuple]
        }

  @doc """
  Creates an image struct from the given `input` and `dimension`.
  """
  @spec new(String.t(), pos_integer) :: t
  def new(input, dimension) do
    %Image{input: input, dimension: dimension}
    |> set_chunk_size()
    |> set_square_size()
    |> set_bytes_length()
    |> set_bytes()
    |> set_color()
    |> Builder.derive_indexes()
    |> Builder.derive_squares()
  end

  ## Private functions

  @spec set_chunk_size(t) :: t
  defp set_chunk_size(%Image{dimension: dimension} = image) do
    put_in(image.chunk_size, round(dimension / 2))
  end

  @spec set_square_size(t) :: t
  defp set_square_size(%Image{dimension: dimension} = image) do
    put_in(image.square_size, round(@side_length / dimension))
  end

  @spec set_bytes_length(t) :: t
  defp set_bytes_length(%Image{dimension: dim, chunk_size: chunk_size} = img) do
    put_in(img.bytes_length, chunk_size * dim)
  end

  @spec set_bytes(t) :: t
  defp set_bytes(%Image{input: input, bytes_length: bytes_length} = image)
       when bytes_length <= 15 do
    # Always returns 16 bytes...
    bytes = :crypto.hash(:md5, input) |> :binary.bin_to_list()
    put_in(image.bytes, Enum.take(bytes, bytes_length))
  end

  defp set_bytes(%Image{input: input, bytes_length: bytes_length} = image) do
    # Always returns 64 bytes...
    bytes = :crypto.hash(:sha512, input) |> :binary.bin_to_list()
    put_in(image.bytes, Enum.take(bytes, bytes_length))
  end

  @spec set_color(t) :: t
  defp set_color(%Image{bytes: [r, g, b | _tail]} = image) do
    put_in(image.color, {r, g, b})
  end
end
