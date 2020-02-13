defmodule Identicon.MixProject do
  use Mix.Project

  def project do
    [
      app: :identicon,
      version: "0.1.12",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      # dialyzer: [plt_add_apps: [:mix]],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Identicon.Top, :ok}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mix_tasks,
       github: "RaymondLoranger/mix_tasks", only: :dev, runtime: false},
      {:log_reset, "~> 0.1"},
      {:persist_config, "~> 0.2", runtime: false},
      {:earmark, "~> 1.0", only: :dev},
      {:ex_doc, "~> 0.14", only: :dev, runtime: false},
      {:dialyxir, "~> 0.5", only: :dev, runtime: false},
      {:egd, github: "erlang/egd"},
      {:logger_file_backend, "~> 0.0.9"}
    ]
  end
end
