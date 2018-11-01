defmodule Identicon.ImageTest do
  use ExUnit.Case, async: true

  alias Identicon.Image

  doctest Image

  setup_all do
    image = %Image{
      color: {114, 179, 2},
      grid: [
        {114, 0},
        {2, 2},
        {114, 4},
        {122, 7},
        {34, 10},
        {138, 11},
        {138, 13},
        {34, 14},
        {124, 22}
      ],
      hex: [
        114,
        179,
        2,
        191,
        41,
        122,
        34,
        138,
        117,
        115,
        1,
        35,
        239,
        239,
        124,
        65
      ],
      pixel_map: [
        {{0, 0}, {50, 50}},
        {{100, 0}, {150, 50}},
        {{200, 0}, {250, 50}},
        {{100, 50}, {150, 100}},
        {{0, 100}, {50, 150}},
        {{50, 100}, {100, 150}},
        {{150, 100}, {200, 150}},
        {{200, 100}, {250, 150}},
        {{100, 200}, {150, 250}}
      ]
    }

    {:ok, image: image}
  end

  describe "Image.build/1" do
    # test "banana", %{image: image} do
    #   IO.inspect(Image.build("banana"))
    #   IO.puts()
    #   IO.inspect(image)
    #   assert Image.build("banana") == image
    # end
  end
end
