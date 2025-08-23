defmodule Identicon.CLI do
  @moduledoc """
  Parses the command line and shows an identicon derived from an input string.

  ##### Based on the course [The Complete Elixir and Phoenix Bootcamp](https://www.udemy.com/the-complete-elixir-and-phoenix-bootcamp-and-tutorial/) by Stephen Grider.

  ##### Reference https://dev.to/paulasantamaria/command-line-interfaces-structure-syntax-2533
  """

  use PersistConfig

  alias Identicon
  alias Identicon.Help

  @default_dimension get_env(:default_dimension)
  @valid_dimensions get_env(:valid_dimensions)
  @valid_durations get_env(:valid_durations)
  @valid_sizes get_env(:valid_sizes)
  @default_switches get_env(:default_switches)
  @parsing_options get_env(:parsing_options)

  @typedoc "GitHub project"
  @type project :: String.t()
  @typedoc "GitHub user"
  @type user :: String.t()

  @doc """
  Parses the command line and prints a table of the first or last _n_ issues
  of a GitHub project.

  `argv` can be "-h" or "--help", which prints info on the command's
  usage and syntax. Otherwise it is a GitHub user, a GitHub project, and
  optionally the number of issues to format (the first _n_ ones).

  To format the last _n_ issues, specify switch `--last`.
  To ring the bell, specify switch `--bell`.
  To choose a table style, specify switch `--table-style`.

  ## Parameters

    - `argv` - command line arguments (list)

  ## Switches

    - `-h` or `--help`        - for help
    - `-b` or `--bell`        - to ring the bell
    - `-l` or `--last`        - to format the last _n_ issues
    - `-t` or `--table-style` - to choose a table style

  ## Examples

      alias GitHub.Issues.CLI
      CLI.main(["Kraigie", "nostrum", "--last", "--no-help"])
      CLI.main(["Kraigie", "nostrum", "--no-last"])
      CLI.main(["Kraigie", "nostrum", "--no-bell", "--table-style", "plain"])
      CLI.main(["Kraigie", "nostrum", "11", "--last"])
      CLI.main(["Kraigie", "nostrum", "--last", "11"])
  """
  @spec main(OptionParser.argv()) :: :ok
  def main(argv) do
    case OptionParser.parse(argv, @parsing_options) do
      {switches, args, []} -> :ok = maybe_show_identicon(switches, args)
      _invalid -> :ok = Help.print_help()
    end
  end

  # @doc """
  # Allows to run command `mix run -e 'GitHub.Issues.CLI.main()'`.

  # The above command is equivalent to:\s\s
  # `mix run -e 'GitHub.Issues.CLI.main([""Kraigie"", ""nostrum"", ""6""])'`

  # ## Examples

  #     $env:MIX_ENV="test"; mix run -e 'GitHub.Issues.CLI.main()'
  #     $env:MIX_ENV="dev"; mix run -e 'GitHub.Issues.CLI.main()'
  #     $env:MIX_ENV="prod"; mix run -e 'GitHub.Issues.CLI.main()'
  # """

  # @spec main :: :ok
  # def main do
  #   :ok = main(["Kraigie", "nostrum", "6"])
  # end

  ## Private functions

  @spec maybe_show_identicon(Keyword.t(), OptionParser.argv()) :: :ok
  defp maybe_show_identicon(switches, [input]) do
    maybe_show_identicon(switches, [input, @default_dimension])
  end

  defp maybe_show_identicon(switches, [input, dimension]) do
    with %{help: false, bell: bell?, size: size, duration: duration} <-
           Map.merge(@default_switches, Map.new(switches)),
         {dim, ""} when dim in @valid_dimensions <- Integer.parse(dimension),
         size when size in @valid_sizes <- size,
         duration when duration in @valid_durations <- duration * 1000 do
      :ok = Identicon.show(input, dim, bell?, size, duration)
    else
      _error -> :ok = Help.print_help()
    end
  end

  defp maybe_show_identicon(_switches, _args) do
    :ok = Help.print_help()
  end
end
