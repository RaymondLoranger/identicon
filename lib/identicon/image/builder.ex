defmodule Identicon.Image.Builder do
  @moduledoc """
  Updates the last fields of an image struct.
  """

  use PersistConfig

  alias Identicon.Image

  @typedoc "Image square index"
  @type square_index :: 0..24

  @squares_across get_env(:squares_across)
  @squares_down get_env(:squares_down)
  @square_size get_env(:square_size)

  @doc """
  Updates field `indexes` of image struct `image`.
  """
  @spec derive_indexes(Image.t()) :: Image.t()
  def derive_indexes(%Image{bytes: bytes} = image) do
    indexes =
      bytes
      # 16 bytes => 5 chunks of 3 bytes discarding the 16th byte...
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_row/1)
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
  def derive_squares(%Image{indexes: indexes} = image) do
    squares =
      Enum.map(indexes, fn index ->
        x = rem(index, @squares_across) * @square_size
        y = div(index, @squares_down) * @square_size
        # Corners (top-left and bottom-right) of colored squares...
        {{x, y}, {x + @square_size, y + @square_size}}
      end)

    put_in(image.squares, squares)
  end

  ## Private functions

  @spec mirror_row([byte]) :: [byte]
  defp mirror_row([first, second, _third] = row), do: row ++ [second, first]

  @spec even_byte_indexes([{byte, square_index}]) :: [square_index]
  defp even_byte_indexes(tuples) do
    for {byte, index} <- tuples, rem(byte, 2) == 0, do: index
  end
end
