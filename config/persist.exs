use Mix.Config

{sep, prog} =
  case :os.type() do
    # File Explorer opens behind other windows...
    # {:win32, _} ->
    #   {"\\", 'explorer'}

    {:win32, _} ->
      {"\\", 'mspaint'}

    {:unix, _} ->
      {"/", 'open'}
  end

config :identicon, program: prog
config :identicon, separator: sep

config :identicon, target_folder: ".#{sep}assets#{sep}identicons"
