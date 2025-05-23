import Config

{open_with, sep} =
  case :os.type() do
    {:win32, :nt} -> {"mspaint", "\\"}
    {:unix, _} -> {"open", "/"}
  end

config :identicon, open_with: open_with
config :identicon, sep: sep
# config :identicon, dir_path: "./assets/identicons/#{config_env()}"

# case config_env() do
#   :dev ->
#     config :file_only_logger, level: :all
#     config :log_reset, levels: :all

#   :prod ->
#     config :file_only_logger, level: :all
#     config :log_reset, levels: :all

#   :test ->
#     config :file_only_logger, level: :all
#     config :log_reset, levels: :all

#   _ ->
#     config :file_only_logger, level: :all
#     config :log_reset, levels: :all
# end
