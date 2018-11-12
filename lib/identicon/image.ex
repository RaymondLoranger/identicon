defmodule Identicon.Image do
  alias __MODULE__
  alias __MODULE__.Builder

  @enforce_keys [:bytes]
  defstruct bytes: [], color: {}, indexes: [], squares: []

  @type t :: %Image{
          bytes: list,
          color: tuple,
          # Indexes of colored squares...
          indexes: list,
          # Colored squares...
          squares: list
        }

  @spec build(String.t()) :: t
  def build(input) do
    input
    |> hash_input()
    |> new()
    |> pick_color()
    |> Builder.build_indexes()
    |> Builder.build_squares()
  end

  ## Private functions

  @spec new([byte]) :: t
  defp new(bytes), do: %Image{bytes: bytes}

  @spec hash_input(String.t()) :: [byte]
  defp hash_input(input), do: :crypto.hash(:md5, input) |> :binary.bin_to_list()

  @spec pick_color(t) :: t
  defp pick_color(%Image{bytes: [r, g, b | _tail]} = image),
    do: put_in(image.color, {r, g, b})
end
