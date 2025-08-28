defmodule Identicon.Drawer do
  @moduledoc """
  Converts an image struct into an identicon.
  """

  alias Identicon
  alias Identicon.Image

  @doc """
  Converts image struct `image` into an identicon.
  """
  @dialyzer {:nowarn_function, [render: 1]}
  @spec render(Image.t()) :: Identicon.t()
  def render(
        %Image{
          dimension: dimension,
          square_size: square_size,
          color: color,
          background: background,
          squares: squares
        } = _image
      ) do
    width = height = square_size * dimension
    # Creates an image area and returns its reference (pid).
    egd_image = :egd.create(width, height)
    bg_color = :egd.color(background)
    :ok = :egd.filledRectangle(egd_image, {0, 0}, {width, height}, bg_color)
    fill_color = :egd.color(color)

    Enum.each(squares, fn {top_left, bottom_right} ->
      # NOTE: An egd (erlang graphical drawer) image is a mutable object!
      :ok = :egd.filledRectangle(egd_image, top_left, bottom_right, fill_color)
    end)

    # Renders a binary in PNG format.
    identicon = :egd.render(egd_image)
    :ok = :egd.destroy(egd_image)
    identicon
  end
end
