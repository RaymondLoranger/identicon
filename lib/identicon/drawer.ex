defmodule Identicon.Drawer do
  @moduledoc """
  Converts an image struct into an identicon.
  """

  use PersistConfig

  alias Identicon
  alias Identicon.Image

  @squares_across get_env(:squares_across)
  @squares_down get_env(:squares_down)
  @square_size get_env(:square_size)

  @image_height @square_size * @squares_down
  @image_width @square_size * @squares_across

  @doc """
  Converts image struct `image` into an identicon.
  """
  @spec render(Image.t()) :: Identicon.t()
  def render(%Image{color: color, squares: squares} = _image) do
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
