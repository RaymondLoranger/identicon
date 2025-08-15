import Config

config :github_issues, default_count: "9"

config :github_issues,
  default_switches: %{
    help: false,
    bell: false
  }

config :github_issues,
  parsing_options: [
    strict: [
      help: :boolean,
      bell: :boolean
    ],
    aliases: [h: :help, b: :bell]
  ]
