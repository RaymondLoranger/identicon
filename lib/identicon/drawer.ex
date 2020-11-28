defmodule Identicon.Drawer do
  use PersistConfig

  alias Identicon.Image

  @squares_across get_env(:squares_across)
  @squares_down get_env(:squares_down)
  @square_size get_env(:square_size)

  @image_height @square_size * @squares_down
  @image_width @square_size * @squares_across

  @spec render(Image.t()) :: binary
  def render(%Image{color: color, squares: squares}) do
    image = :egd.create(@image_width, @image_height)
    fill = :egd.color(color)

    Enum.each(squares, fn {top_left, bottom_right} ->
      :ok = :egd.filledRectangle(image, top_left, bottom_right, fill)
    end)

    binary = :egd.render(image)
    :ok = :egd.destroy(image)
    binary
  end
end
