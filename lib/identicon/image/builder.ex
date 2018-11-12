defmodule Identicon.Image.Builder do
  alias Identicon.Image

  @spec build_indexes(Image.t()) :: Image.t()
  def build_indexes(%Image{charlist: charlist} = image) do
    indexes =
      charlist
      # Always 5 chunks of 3 chars...
      |> Stream.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_row/1)
      |> List.flatten()
      |> Enum.with_index()
      |> filter_even_indexes()

    put_in(image.indexes, indexes)
  end

  @spec build_squares(Image.t()) :: Image.t()
  def build_squares(%Image{indexes: indexes} = image) do
    squares =
      Enum.map(indexes, fn index ->
        horizontal = rem(index, 5) * 50
        vertical = div(index, 5) * 50
        top_left = {horizontal, vertical}
        bottom_right = {horizontal + 50, vertical + 50}
        {top_left, bottom_right}
      end)

    put_in(image.squares, squares)
  end

  ## Private functions

  @spec mirror_row([0..255]) :: [0..255]
  defp mirror_row([first, second, _third] = row), do: row ++ [second, first]

  @spec filter_even_indexes([{0..255, 0..24}]) :: [0..24]
  defp filter_even_indexes(tuples) do
    require Integer

    tuples
    |> Enum.filter(fn {char, _index} -> Integer.is_even(char) end)
    |> Enum.map(fn {_char, index} -> index end)
  end
end
