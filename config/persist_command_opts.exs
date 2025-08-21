import Config

config :identikon,
  default_switches: %{
    help: false
  }

config :identikon,
  parsing_options: [
    strict: [
      help: :boolean
    ],
    aliases: [h: :help]
  ]
