defmodule Identicon.MixProject do
  use Mix.Project

  def project do
    [
      app: :identicon,
      version: "0.1.22",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:crypto, :logger],
      mod: {Identicon.TopSup, :ok}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:egd, github: "erlang/egd"},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:file_only_logger, "~> 0.1"},
      {:log_reset, "~> 0.1"},
      {:persist_config, "~> 0.4", runtime: false}
    ]
  end
end
