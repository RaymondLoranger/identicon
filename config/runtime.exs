import Config

{separator, open_with, close_cmd} =
  case :os.type() do
    {:win32, :nt} -> {"\\", "mspaint", ~c"taskkill /im mspaint.exe /t /f"}
    {:unix, __os} -> {"/", "open", ~c"killall Preview"}
  end

directory = "./assets/identicons/#{config_env()}"

config :identikon, separator: separator
config :identikon, open_with: open_with
config :identikon, close_cmd: close_cmd
config :identikon, directory: Path.expand(directory)
