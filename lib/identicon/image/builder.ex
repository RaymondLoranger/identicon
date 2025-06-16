defmodule Identicon.Image.Builder do
  @moduledoc """
  Updates fields `indexes` and `squares` of an image struct.
  """

  use PersistConfig

  alias Identicon.Image

  @typedoc "Image square index"
  @type square_index :: non_neg_integer

  @doc """
  Updates field `indexes` of image struct `image`.
  """
  @spec derive_indexes(Image.t()) :: Image.t()
  def derive_indexes(
        %Image{
          dimension: dimension,
          chunk_size: chunk_size,
          bytes: bytes
        } = image
      ) do
    indexes =
      bytes
      |> Enum.chunk_every(chunk_size)
      |> Enum.map(&mirror_chunk(&1, dimension))
      |> List.flatten()
      |> Enum.with_index()
      |> even_byte_indexes()

    # Indexes of colored squares...
    put_in(image.indexes, indexes)
  end

  @doc """
  Updates field `squares` of image struct `image`.
  """
  @spec derive_squares(Image.t()) :: Image.t()
  def derive_squares(
        %Image{
          dimension: dimension,
          square_size: square_size,
          indexes: indexes
        } = image
      ) do
    squares =
      Enum.map(indexes, fn index ->
        x = rem(index, dimension) * square_size
        y = div(index, dimension) * square_size
        # Corners (top-left and bottom-right) of colored squares...
        {{x, y}, {x + square_size - 1, y + square_size - 1}}
      end)

    put_in(image.squares, squares)
  end

  ## Private functions

  @spec mirror_chunk([byte], pos_integer) :: [[byte] | byte]
  defp mirror_chunk(chunk, dimension) when rem(dimension, 2) == 0,
    # E.g. for dimension 8 => [[1, 2, 3, 4], 4, 3, 2, 1]
    do: [chunk | Enum.reverse(chunk)]

  defp mirror_chunk(chunk, _dimension),
    # E.g. for dimension 7 => [[1, 2, 3, 4], 3, 2, 1]
    do: [chunk | Enum.drop(chunk, -1) |> Enum.reverse()]

  @spec even_byte_indexes([{byte, square_index}]) :: [square_index]
  defp even_byte_indexes(tuples) do
    for {byte, index} <- tuples, rem(byte, 2) == 0, do: index
  end
end
