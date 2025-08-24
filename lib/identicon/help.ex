defmodule Identicon.Help do
  @moduledoc """
  Prints info on the escript command's usage and syntax.

  Reference https://dev.to/paulasantamaria/command-line-interfaces-structure-syntax-2533
  """

  use PersistConfig

  alias IO.ANSI.Plus, as: ANSI

  @default_dimension get_env(:default_dimension)
  @default_switches get_env(:default_switches)
  @escript Mix.Project.config()[:escript][:name]
  @help_attrs get_env(:help_attrs)
  @valid_dimensions get_env(:valid_dimensions)
  @valid_durations get_env(:valid_durations)
  @valid_sizes get_env(:valid_sizes)

  @doc """
  Prints info on the escript command's usage and syntax.

  ## Examples

      ic --help
      ic coconut 7 --size 300 --duration 4
      ic papaya -s 350 -d 5 --no-bell
      ic lychee 9
  """
  @spec print_help :: :ok
  def print_help do
    texts = ["usage:", " #{@escript}"]
    length = Enum.join(texts) |> String.length()
    filler = String.duplicate(" ", length)
    prefix = help_format([:section, :normal], texts)

    line_arguments =
      help_format([:arg], ["<input> [<dimension>]"])

    line_flags = help_format([:switch], ["[-b | --bell]"])

    line_size =
      help_format([:switch, :arg, :switch], [
        "[-s | --size ",
        "<size>",
        "]"
      ])

    line_duration =
      help_format([:switch, :arg, :switch], [
        "[-d | --duration ",
        "<duration>",
        "]"
      ])

    line_where = help_format([:section], ["where:"])

    line_default_dimension =
      help_format([:normal, :arg, :normal, :value, :normal], [
        "  - default ",
        "<dimension>",
        " is ",
        "#{@default_dimension}",
        " (squares)"
      ])

    line_values_of_dimensions =
      help_format([:normal, :arg, :normal, :value], [
        "  - ",
        "<dimension>",
        " can be ",
        "#{values_of(@valid_dimensions)}"
      ])

    line_default_size =
      help_format([:normal, :arg, :normal, :value, :normal], [
        "  - default ",
        "<size>",
        " is ",
        "#{@default_switches[:size]}",
        " (pixels)"
      ])

    line_values_of_size =
      help_format([:normal, :arg, :normal, :value], [
        "  - ",
        "<size>",
        " can be ",
        "#{values_of(@valid_sizes)}"
      ])

    line_default_duration =
      help_format([:normal, :arg, :normal, :value, :normal], [
        "  - default ",
        "<duration>",
        " is ",
        "#{@default_switches[:duration]}",
        " (seconds)"
      ])

    line_values_of_duration =
      help_format([:normal, :arg, :normal, :value], [
        "  - ",
        "<duration>",
        " can be ",
        "#{values_of(@valid_durations)}"
      ])

    IO.write("""
    #{prefix} #{line_arguments}
    #{filler} #{line_flags}
    #{filler} #{line_size}
    #{filler} #{line_duration}
    #{line_where}
    #{line_default_dimension}
    #{line_values_of_dimensions}
    #{line_default_size}
    #{line_values_of_size}
    #{line_default_duration}
    #{line_values_of_duration}
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

  defp values_of(range) do
    Enum.to_list(range) |> inspect() |> String.slice(1..-2//1)
  end
end
