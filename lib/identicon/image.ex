defmodule Identicon.Image do
  alias __MODULE__
  alias __MODULE__.Builder

  @enforce_keys [:charlist]
  defstruct charlist: [], color: {}, indexes: [], squares: []

  @type t :: %Image{
          charlist: charlist,
          color: tuple,
          indexes: list,
          squares: list
        }

  @spec build(String.t()) :: t
  def build(input) do
    input
    |> hash_input()
    |> pick_color()
    |> Builder.build_indexes()
    |> Builder.build_squares()
  end

  ## Private functions

  @spec new([0..255]) :: t
  defp new(charlist), do: %Image{charlist: charlist}

  @spec hash_input(String.t()) :: t
  defp hash_input(input),
    do: :crypto.hash(:md5, input) |> :binary.bin_to_list() |> new()

  @spec pick_color(t) :: t
  defp pick_color(%Image{charlist: [r, g, b | _tail]} = image),
    do: put_in(image.color, {r, g, b})
end
