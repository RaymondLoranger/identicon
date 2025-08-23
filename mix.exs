defmodule Identicon.MixProject do
  # NOTE: Only compiles with Erlang/OTP 26 [erts-14.2.2]...
  # NOTE: With later versions, cannot compile bbmustache...
  # Add -feature(maybe_expr, disable).
  # after -module(bbmustache).
  # in file ...deps/egd/_build/default/plugins/bbmustache/src/bbmustache.erl
  # and then run mix deps.compile egd
  use Mix.Project

  def project do
    [
      app: :identikon,
      version: "0.1.32",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      name: "Identicon",
      source_url: source_url(),
      description: description(),
      package: package(),
      escript: escript(),
      deps: deps()
    ]
  end

  defp source_url do
    "https://github.com/RaymondLoranger/identicon"
  end

  defp description do
    """
    Opens an identicon file derived from an input string and a dimension.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "config/persist*.exs"],
      maintainers: ["Raymond Loranger"],
      licenses: ["MIT"],
      links: %{"GitHub" => source_url()}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:crypto, :logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      # See link below for an explanation of this github replacement...
      # {:egd, github: "erlang/egd"},
      {:egd, github: "RaymondLoranger/egd"},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:file_only_logger, "~> 0.2"},
      {:io_ansi_plus, "~> 0.1"},
      {:log_reset, "~> 0.1"},
      {:persist_config, "~> 0.4", runtime: false}
    ]
  end

  defp escript do
    [
      main_module: Identicon.CLI,
      name: :ic
    ]
  end
end

# https://elixirforum.com/t/error-when-rendring-in-egd-undefinedfunctionerror-function-zlib-crc32-2-is-undefined-or-private/66639
