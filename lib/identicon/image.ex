defmodule Identicon.Image do
  @moduledoc """
  Creates an image struct to be converted into an identicon.

  The image struct contains the fields `input`, `dimension`, `chunk_size`,
  `square_size`, `bytes_length`, `hash_algo`, `bytes`, `color`, `background`,
  `indexes` and `squares` representing the properties of an identicon image.
  """

  use PersistConfig

  alias __MODULE__
  alias __MODULE__.Builder

  @enforce_keys [:input, :dimension]
  defstruct input: "",
            dimension: 5,
            chunk_size: 3,
            square_size: round(250 / 5),
            bytes_length: 3 * 5,
            hash_algo: :md5,
            bytes: [],
            color: {},
            background: {},
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
          hash_algo: atom,
          # Digest bytes...
          bytes: [byte],
          color: tuple,
          background: tuple,
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
    |> set_hash_algo()
    |> set_bytes()
    |> set_color()
    |> set_background()
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
    put_in(image.square_size, round(side_length() / dimension))
  end

  @spec set_bytes_length(t) :: t
  defp set_bytes_length(%Image{dimension: dim, chunk_size: chunk_size} = img) do
    put_in(img.bytes_length, chunk_size * dim)
  end

  @spec set_hash_algo(t) :: t
  defp set_hash_algo(%Image{dimension: 5, bytes_length: 15} = image) do
    # :md5 always returns 16 bytes...
    put_in(image.hash_algo, :md5)
  end

  defp set_hash_algo(%Image{dimension: 6, bytes_length: 18} = image) do
    # :sha always returns 20 bytes...
    put_in(image.hash_algo, :sha)
  end

  defp set_hash_algo(%Image{dimension: 7, bytes_length: 28} = image) do
    # :sha224 always returns 28 bytes...
    put_in(image.hash_algo, :sha224)
  end

  defp set_hash_algo(%Image{dimension: 8, bytes_length: 32} = image) do
    # :sha256 always returns 32 bytes...
    put_in(image.hash_algo, :sha256)
  end

  defp set_hash_algo(%Image{dimension: 9, bytes_length: 45} = image) do
    # :sha384 always returns 48 bytes...
    put_in(image.hash_algo, :sha384)
  end

  defp set_hash_algo(%Image{dimension: 10, bytes_length: 50} = image) do
    # :sha512 always returns 64 bytes...
    put_in(image.hash_algo, :sha512)
  end

  @spec set_bytes(t) :: t
  defp set_bytes(
         %Image{
           input: input,
           bytes_length: bytes_length,
           hash_algo: hash_algo
         } = image
       ) do
    bytes = :crypto.hash(hash_algo, input) |> :binary.bin_to_list()
    put_in(image.bytes, Enum.take(bytes, bytes_length))
  end

  @spec set_color(t) :: t
  defp set_color(%Image{bytes: [r, g, b | _tail]} = image) do
    put_in(image.color, {r, g, b})
  end

  @spec set_background(t) :: t
  defp set_background(%Image{color: {r, g, b}} = image) do
    # Find the complementary color...
    put_in(image.background, {255 - r, 255 - g, 255 - b})
  end

  # Identicon side length in pixels...
  @spec side_length :: pos_integer
  defp side_length, do: get_env(:side_length)
end
