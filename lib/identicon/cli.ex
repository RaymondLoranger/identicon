defmodule Identicon.CLI do
  @moduledoc """
  Parses the command line and displays an identicon derived from an input
  string, a dimension and a size.

  ##### Based on the course [The Complete Elixir and Phoenix Bootcamp](https://www.udemy.com/the-complete-elixir-and-phoenix-bootcamp-and-tutorial/) by Stephen Grider.

  ##### Reference https://dev.to/paulasantamaria/command-line-interfaces-structure-syntax-2533
  """

  use PersistConfig

  alias Identicon
  alias Identicon.Help

  @default_dimension get_env(:default_dimension)
  @default_dimension to_string(@default_dimension)
  @default_switches get_env(:default_switches)
  @parsing_options get_env(:parsing_options)
  @valid_dimensions get_env(:valid_dimensions)
  @valid_durations get_env(:valid_durations)
  @valid_sizes get_env(:valid_sizes)

  @doc """
  Parses the command line and displays an identicon derived from an input
  string, a dimension and a size.

  `argv` can be "-h" or "--help", which prints info on the command's usage and
  syntax. Otherwise it is an input string and optionally the identicon
  dimension, its overall size and its display duration.

  ## Parameters

    - `argv` - command line arguments (list)

  ## Switches

    - `-h` or `--help`     - for help
    - `-b` or `--bell`     - to ring the bell
    - `-s` or `--size`     - identicon size in pixels
    - `-d` or `--duration` - identicon display duration in seconds

  ## Examples

      alias Identicon.CLI
      CLI.main(["fig", "6", "--size", "300", "--duration", "6", "--no-bell"])
      CLI.main(["guava"])
      CLI.main(["apricot", "10", "-s", "350", "--no-help"])
  """
  @spec main(OptionParser.argv()) :: :ok
  def main(argv) do
    case OptionParser.parse(argv, @parsing_options) do
      {switches, args, []} -> :ok = maybe_display_identicon(switches, args)
      _invalid -> :ok = Help.print_help()
    end
  end

  @doc """
  Allows to run command `mix run -e 'Identicon.CLI.main()'`.

  The above command is equivalent to:\s\s
  `mix run -e 'Identicon.CLI.main([""pumpkin"", ""7""])'`

  ## Examples

      $env:MIX_ENV="test"; mix run -e 'Identicon.CLI.main()'
      $env:MIX_ENV="dev";  mix run -e 'Identicon.CLI.main()'
      $env:MIX_ENV="prod"; mix run -e 'Identicon.CLI.main()'
  """
  @spec main :: :ok
  def main do
    :ok = main(["pumpkin", "7"])
  end

  ## Private functions

  @spec maybe_display_identicon(keyword, OptionParser.argv()) :: :ok
  defp maybe_display_identicon(switches, [input]) do
    maybe_display_identicon(switches, [input, @default_dimension])
  end

  defp maybe_display_identicon(switches, [input, dimension]) do
    with %{help: false, bell: bell?, size: size, duration: duration} <-
           Map.merge(@default_switches, Map.new(switches)),
         {dim, ""} when dim in @valid_dimensions <- Integer.parse(dimension),
         size when size in @valid_sizes <- size,
         duration when duration in @valid_durations <- duration do
      options = [dimension: dim, size: size, duration: duration, bell: bell?]
      :ok = Identicon.display(input, options)
    else
      _error -> :ok = Help.print_help()
    end
  end

  defp maybe_display_identicon(_switches, _args) do
    :ok = Help.print_help()
  end
end
