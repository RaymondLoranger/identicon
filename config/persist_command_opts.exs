import Config

config :identikon,
  default_switches: %{
    help: false,
    bell: false,
    size: 250,
    duration: 3
  }

config :identikon,
  parsing_options: [
    strict: [
      help: :boolean,
      bell: :boolean,
      size: :integer,
      duration: :integer
    ],
    aliases: [h: :help, b: :bell, s: :size, d: :duration]
  ]
