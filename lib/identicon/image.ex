defmodule Identicon.Image do
  @moduledoc false

  alias __MODULE__

  @enforce_keys [:hex]
  defstruct hex: [], color: {}, grid: [], pixel_map: []

  @type t :: %Image{hex: list, color: tuple, grid: list, pixel_map: list}

  @spec build(String.t()) :: t
  def build(input) do
    input
    |> hash_input()
    |> pick_color()
    |> build_grid()
    |> filter_even_squares()
    |> build_pixel_map()
  end

  ## Private functions

  @spec init([non_neg_integer]) :: t
  defp init(hex), do: %Image{hex: hex}

  @spec hash_input(String.t()) :: t
  defp hash_input(input) do
    :crypto.hash(:md5, input) |> :binary.bin_to_list() |> init()
  end

  @spec pick_color(t) :: t
  defp pick_color(%Image{hex: [r, g, b | _tail]} = image) do
    struct(image, color: {r, g, b})
  end

  @spec build_grid(t) :: t
  defp build_grid(%Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk(3)
      |> Enum.map(&mirror_row/1)
      |> List.flatten()
      |> Enum.with_index()

    struct(image, grid: grid)
  end

  @spec mirror_row([non_neg_integer]) :: [non_neg_integer]
  defp mirror_row([first, second, third]) do
    [first, second, third, second, first]
  end

  @spec filter_even_squares(t) :: t
  defp filter_even_squares(%Image{grid: grid} = image) do
    require Integer
    grid = Enum.filter(grid, fn {code, _index} -> Integer.is_even(code) end)
    struct(image, grid: grid)
  end

  @spec build_pixel_map(t) :: t
  defp build_pixel_map(%Image{grid: grid} = image) do
    pixel_map =
      Enum.map(grid, fn {_code, index} ->
        horizontal = rem(index, 5) * 50
        vertical = div(index, 5) * 50
        top_left = {horizontal, vertical}
        bottom_right = {horizontal + 50, vertical + 50}
        {top_left, bottom_right}
      end)

    struct(image, pixel_map: pixel_map)
  end
end
