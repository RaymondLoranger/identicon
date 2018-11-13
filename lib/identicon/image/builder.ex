defmodule Identicon.Image.Builder do
  use PersistConfig

  alias Identicon.Image

  @type square_index :: 0..24

  @square_size Application.get_env(@app, :square_size)
  @squares_across Application.get_env(@app, :squares_across)
  @squares_down Application.get_env(@app, :squares_down)

  @spec derive_indexes(Image.t()) :: Image.t()
  def derive_indexes(%Image{bytes: bytes} = image) do
    indexes =
      bytes
      # Always 5 chunks of 3 bytes...
      |> Stream.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_row/1)
      |> List.flatten()
      |> Enum.with_index()
      |> even_byte_indexes()

    put_in(image.indexes, indexes)
  end

  @spec derive_squares(Image.t()) :: Image.t()
  def derive_squares(%Image{indexes: indexes} = image) do
    squares =
      Enum.map(indexes, fn index ->
        x = rem(index, @squares_across) * @square_size
        y = div(index, @squares_down) * @square_size
        {{x, y}, {x + @square_size, y + @square_size}}
      end)

    put_in(image.squares, squares)
  end

  ## Private functions

  @spec mirror_row([byte]) :: [byte]
  defp mirror_row([first, second, _third] = row), do: row ++ [second, first]

  @spec even_byte_indexes([{byte, square_index}]) :: [square_index]
  defp even_byte_indexes(tuples) do
    tuples
    |> Enum.filter(fn {byte, _index} -> rem(byte, 2) == 0 end)
    |> Enum.map(fn {_byte, index} -> index end)
  end
end
