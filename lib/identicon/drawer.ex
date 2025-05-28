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
    # Creates an image area and returns its reference (pid).
    egd_image = :egd.create(@image_width, @image_height)
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
