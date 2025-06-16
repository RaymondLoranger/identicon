defmodule Identicon.Drawer do
  @moduledoc """
  Converts an image struct into an identicon.
  """

  alias Identicon
  alias Identicon.Image

  @doc """
  Converts image struct `image` into an identicon.
  """
  @spec render(Image.t()) :: Identicon.t()
  def render(
        %Image{
          dimension: dimension,
          square_size: square_size,
          color: color,
          squares: squares
        } = _image
      ) do
    area_width = area_height = square_size * dimension
    # Creates an image area and returns its reference (pid).
    egd_image = :egd.create(area_width, area_height)
    fill_color = :egd.color(color)

    Enum.each(squares, fn {top_left, bottom_right} ->
      # NOTE: An egd (erlang graphical drawer) image is a mutable object!
      :ok = :egd.filledRectangle(egd_image, top_left, bottom_right, fill_color)
    end)

    # Renders a binary in png format.
    identicon = :egd.render(egd_image)
    :ok = :egd.destroy(egd_image)
    identicon
  end
end
