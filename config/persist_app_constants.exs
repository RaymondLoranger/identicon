import Config

config :identikon, default_dimension: "5" # number of squares across and down
config :identikon, valid_dimensions: 5..10
config :identikon, valid_sizes: 250..350//50 # identicon sizes in pixels
config :identikon, valid_durations: 3..9 # display durations in seconds

root_dir = File.cwd!()
directory = "#{root_dir}/assets/identicons/#{Mix.env()}"
File.mkdir_p(directory)

config :identikon, directory: Path.expand(directory)
