import Config

{open_with, sep, close_cmd} =
  case :os.type() do
    {:win32, :nt} -> {"mspaint", "\\", ~c"taskkill /im mspaint.exe /t /f"}
    {:unix, _} -> {"open", "/", ~c"killall Preview"}
  end

config :identicon, open_with: open_with
config :identicon, sep: sep
config :identicon, close_cmd: close_cmd
# config :identicon, default_dir_path: "./assets/identicons/#{config_env()}"

case config_env() do
  :dev ->
    # config :file_only_logger, level: :all
    # config :log_reset, levels: :all
    config :identicon, side_length: 250 # pixels
    config :identicon, show_timeout: 3000 # ms

  :prod ->
    # config :file_only_logger, level: :all
    # config :log_reset, levels: :all
    config :identicon, side_length: 250 # pixels
    config :identicon, show_timeout: 3000 # ms

  :test ->
    # config :file_only_logger, level: :all
    # config :log_reset, levels: :all
    config :identicon, side_length: 250 # pixels
    config :identicon, show_timeout: 3000 # ms

  _ ->
    # config :file_only_logger, level: :all
    # config :log_reset, levels: :all
    config :identicon, side_length: 250 # pixels
    config :identicon, show_timeout: 3000 # ms
end
