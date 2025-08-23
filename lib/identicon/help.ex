defmodule Identicon.Help do
  @moduledoc """
  Prints info on the escript command's usage and syntax.

  Reference https://dev.to/paulasantamaria/command-line-interfaces-structure-syntax-2533
  """

  use PersistConfig

  alias IO.ANSI.Plus, as: ANSI

  @default_dimension get_env(:default_dimension)
  @default_switches get_env(:default_switches)
  @valid_sizes get_env(:valid_sizes)
  @valid_durations get_env(:valid_durations)
  @escript Mix.Project.config()[:escript][:name]
  @help_attrs get_env(:help_attrs)

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
      help_format([:arg], ["<arbitrary-string> [<identicon-dimension>]"])

    line_flags = help_format([:switch], ["[-b | --bell]"])

    line_size =
      help_format([:switch, :arg, :switch], [
        "[-s | --size ",
        "<identicon-size-in-pixels>",
        "]"
      ])

    line_duration =
      help_format([:switch, :arg, :switch], [
        "[-d | --duration ",
        "<display-time-in-seconds>",
        "]"
      ])

    line_where = help_format([:section], ["where:"])

    line_default_dimension =
      help_format([:normal, :arg, :normal, :value], [
        "  - default ",
        "<identicon-dimension>",
        " is ",
        "#{@default_dimension}"
      ])

    line_default_size =
      help_format([:normal, :arg, :normal, :value], [
        "  - default ",
        "<identicon-size-in-pixels>",
        " is ",
        "#{@default_switches[:size]}"
      ])

    line_values_of_size =
      help_format([:normal, :arg, :normal, :value], [
        "  - values of ",
        "<identicon-size-in-pixels>",
        " are ",
        "#{Enum.to_list(@valid_sizes) |> inspect() |> String.slice(1..-2//1)}"
      ])

    line_default_duration =
      help_format([:normal, :arg, :normal, :value], [
        "  - default ",
        "<display-time-in-seconds>",
        " is ",
        "#{@default_switches[:duration]}"
      ])

    line_values_of_duration =
      help_format([:normal, :arg, :normal, :value], [
        "  - values of ",
        "<display-time-in-seconds>",
        " are ",
        "#{Enum.to_list(@valid_durations) |> inspect() |> String.slice(1..-2//1)}"
      ])

    IO.write("""
    #{prefix} #{line_arguments}
    #{filler} #{line_flags}
    #{filler} #{line_size}
    #{filler} #{line_duration}
    #{line_where}
    #{line_default_dimension}
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
end
