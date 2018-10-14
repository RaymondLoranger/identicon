use Mix.Config

{separator, program} =
  case :os.type() do
    # File Explorer opens behind other windows...
    # {:win32, _} ->
    #   {"\\", 'explorer'}

    {:win32, _} ->
      {"\\", 'mspaint'}

    {:unix, _} ->
      {"/", 'open'}
  end

config :identicon, program: program
config :identicon, separator: separator

config :identicon, target_folder: ".#{separator}assets#{separator}identicons"
