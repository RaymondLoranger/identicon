defmodule Identicon.Help do
  @moduledoc """
  Prints info on the escript command's usage and syntax.

  Reference https://dev.to/paulasantamaria/command-line-interfaces-structure-syntax-2533
  """

  use PersistConfig

  alias IO.ANSI.Plus, as: ANSI

  @default_dimension get_env(:default_dimension)
  @escript Mix.Project.config()[:escript][:name]
  @help_attrs get_env(:help_attrs)

  @doc """
  Prints info on the escript command's usage and syntax.

  ## Examples

      ic --help
      ic coconut 7
      ic papaya
      ic lychee 9
  """
  @spec print_help :: :ok
  def print_help do
    texts = ["usage:", " #{@escript}"]
    length = Enum.join(texts) |> String.length()
    filler = String.duplicate(" ", length)
    prefix = help_format([:section, :normal], texts)

    line_arguments =
      help_format([:arg], ["<arbitrary-string> [<dimension>]"])

    line_flags = help_format([:switch], ["[-b | --bell]"])

    line_where = help_format([:section], ["where:"])

    line_default_dimension =
      help_format([:normal, :arg, :normal, :value], [
        "  - default ",
        "<dimension>",
        " is ",
        "#{@default_dimension}"
      ])

    IO.write("""
    #{prefix} #{line_arguments}
    #{filler} #{line_flags}
    #{line_where}
    #{line_default_dimension}
    """)
  end

  ## Private functions

  @spec help_format([atom], [String.t()]) :: IO.chardata()
  defp help_format(types, texts) do
    Enum.map(types, &@help_attrs[&1])
    |> Enum.zip(texts)
    |> Enum.map(&Tuple.to_list/1)
    |> ANSI.format()
  end
end
