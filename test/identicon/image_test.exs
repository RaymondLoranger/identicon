defmodule Identicon.ImageTest do
  use ExUnit.Case, async: true

  alias Identicon.{Image, Log}

  doctest Image
  doctest Image, only: TestHelper.doctests(Image)

  setup_all do
    image = %Image{
      color: {114, 179, 2},
      # 9 indexes of 9 colored squares
      indexes: [0, 2, 4, 7, 10, 11, 13, 14, 22],
      bytes: [
        114, 179,   2, 191,
         41, 122,  34, 138,
        117, 115,   1,  35,
        239, 239, 124,  65
      ],
      # 9 corner tuples of 9 colored squares
      squares: [
        {{  0,   0}, { 50 - 1,  50 - 1}},
        {{100,   0}, {150 - 1,  50 - 1}},
        {{200,   0}, {250 - 1,  50 - 1}},
        {{100,  50}, {150 - 1, 100 - 1}},
        {{  0, 100}, { 50 - 1, 150 - 1}},
        {{ 50, 100}, {100 - 1, 150 - 1}},
        {{150, 100}, {200 - 1, 150 - 1}},
        {{200, 100}, {250 - 1, 150 - 1}},
        {{100, 200}, {150 - 1, 250 - 1}}
      ]
    }

    %{image: image}
  end

  describe "Image.new/1" do
    @tag :image_test_1
    TestHelper.config_level(__MODULE__)

    test "returns an image struct having field color", %{image: image} do
      :ok = Log.debug(:image_test_1, {image.color, __ENV__})
      assert Image.new("banana").color == image.color
    end

    @tag :image_test_2
    TestHelper.config_level(__MODULE__)

    test "returns an image struct having field indexes", %{image: image} do
      :ok = Log.debug(:image_test_2, {image.indexes, __ENV__})
      assert Image.new("banana").indexes == image.indexes
    end

    Logger.configure(level: :all)

    @tag :image_test_3
    TestHelper.config_level(__MODULE__)

    test "returns an image struct", %{image: image} do
      :ok = Log.debug(:image_test_3, {image, __ENV__})
      assert Image.new("banana") == image
    end

    Logger.configure(level: :all)
  end
end
