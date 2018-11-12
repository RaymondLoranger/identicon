use Mix.Config

{identicon_pgm, sep} =
  case :os.type() do
    {:win32, _} -> {"", "\\"}
    {:unix, _} -> {"open", "/"}
  end

config :identicon, identicon_dir: ".#{sep}assets#{sep}identicons#{sep}"
config :identicon, identicon_pgm: identicon_pgm
