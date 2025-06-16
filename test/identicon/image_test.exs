defmodule Identicon.ImageTest do
  use ExUnit.Case, async: true

  alias Identicon.{Image, Log}

  doctest Image
  doctest Image, only: TestHelper.doctests(Image)

  setup_all do
    banana = %Image{
      input: "banana",
      dimension: 5,
      chunk_size: 3,
      square_size: 50,
      bytes_length: 15,
      # 5 chunks of 3 squares...
      bytes: [
        114, 179,   2,
        191,  41, 122,
         34, 138, 117,
        115,   1,  35,
        239, 239, 124
      ],
      color: {114, 179, 2},
      # 9 indexes of 9 colored squares
      indexes: [0, 2, 4, 7, 10, 11, 13, 14, 22],
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

    %{image: banana}
  end

  describe "Image.new/1" do
    @tag :image_test_1
    test "returns an image struct having field color", %{image: banana} do
      :ok = Log.debug(:assert_banana_color, {banana.color, __ENV__})
      assert Image.new(banana.input, banana.dimension).color == banana.color
    end

    @tag :image_test_2
    test "returns an image struct having field indexes", %{image: banana} do
      Log.debug(:assert_banana_indexes, {banana.indexes, __ENV__})
      assert Image.new(banana.input, banana.dimension).indexes == banana.indexes
    end

    @tag :image_test_3
    test "returns an image struct", %{image: banana} do
      :ok = Log.debug(:assert_banana_struct, {banana, __ENV__})
      assert Image.new(banana.input, banana.dimension) == banana
    end
  end
end
