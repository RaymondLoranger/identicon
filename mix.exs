defmodule Identicon.MixProject do
  # NOTE: Only compiles with Erlang/OTP 26 [erts-14.2.2]...
  # NOTE: With later versions, cannot compile bbmustache...
  use Mix.Project

  def project do
    [
      app: :identicon,
      version: "0.1.32",
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
      # See link below for an explanation of this github replacement...
      # {:egd, github: "erlang/egd"},
      {:egd, github: "RaymondLoranger/egd"},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:file_only_logger, "~> 0.2"},
      {:log_reset, "~> 0.1"},
      {:persist_config, "~> 0.4", runtime: false}
    ]
  end
end

# https://elixirforum.com/t/error-when-rendring-in-egd-undefinedfunctionerror-function-zlib-crc32-2-is-undefined-or-private/66639
