# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# Mix messages in colors...
config :elixir, ansi_enabled: true

config :logger,
  backends: [
    # :console,
    {LoggerFileBackend, :info_log}
  ]

# Purges debug messages...
config :logger, compile_time_purge_level: :info

# Prevents debug messages...
config :logger, level: :info

config :logger, :console,
  colors: [
    debug: :light_cyan,
    info: :light_green,
    warn: :light_yellow,
    error: :light_red
  ]

format = "$date $time [$level] $levelpad$message\n"

config :logger, :console, format: format

config :logger, :info_log, format: format
config :logger, :info_log, path: "./log/info.log", level: :info

#     import_config "#{Mix.env}.exs"
import_config "persist.exs"
import_config "persist_book_ref.exs"
