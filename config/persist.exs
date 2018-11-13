use Mix.Config

{identicon_pgm, sep} =
  case :os.type() do
    {:win32, _} -> {"", "\\"}
    {:unix, _} -> {"open", "/"}
  end

config :identicon, identicon_dir: ".#{sep}identicons#{sep}"
config :identicon, identicon_pgm: identicon_pgm
config :identicon, square_size: 50
config :identicon, squares_across: 5
config :identicon, squares_down: 5
