defmodule Identicon.MixProject do
  use Mix.Project

  def project do
    [
      app: :identicon,
      version: "0.1.7",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [plt_add_apps: [:mix]]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Identicon.App, :ok},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mix_tasks,
       github: "RaymondLoranger/mix_tasks", only: :dev, runtime: false},
      {:persist_config, "~> 0.2"},
      {:earmark, "~> 1.0", only: :dev},
      {:ex_doc, "~> 0.14", only: :dev, runtime: false},
      {:egd, github: "erlang/egd"},
      {:dialyxir, "~> 0.5", only: :dev, runtime: false},
      {:logger_file_backend, "~> 0.0.9"}
    ]
  end
end
