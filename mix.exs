defmodule Identicon.MixProject do
  use Mix.Project

  def project do
    [
      app: :identikon,
      version: "0.1.5",
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
    Opens an identicon PNG derived from an input string, a dimension and a size.
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
      # See the links below for an explanation of this :egd replacement...
      # {:egd, github: "erlang/egd"},
      {:egd, "~> 0.10.1", hex: :egd24},
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

# https://github.com/erlang/egd/pull/1
