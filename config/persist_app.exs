use Mix.Config

{open_with, sep} =
  case :os.type() do
    {:win32, _} -> {"mspaint", "\\"}
    {:unix, _} -> {"open", "/"}
  end

config :identicon, identicon_dir: "./assets/identicons/"
config :identicon, open_with: open_with
config :identicon, sep: sep
config :identicon, square_size: 50
config :identicon, squares_across: 5
config :identicon, squares_down: 5
