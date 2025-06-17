import Config

config :identicon, default_dir_path: "./assets/identicons/"
config :identicon, default_dimension: 5 # squares across or down
config :identicon, valid_dimensions: 5..10
config :identicon, side_length: 250 # pixels
config :identicon, show_timeout: 3000 # ms
