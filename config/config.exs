# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :inn_checker,
  ecto_repos: [InnChecker.Repo]

config :inn_checker,
  redis_host: "localhost",
  redis_port: 6379,
  redis_database: nil,
  redis_password: nil,
  redis_name: :redix

# config :inn_checker,
#   redis_host: "ec2-54-198-175-32.compute-1.amazonaws.com",
#   redis_port: 25429,
#   redis_database: nil,
#   redis_password: "p3d58396416900fb1cbaa16337d7648243d0ee6e5ff2150b150bf4ab4041eea75",
#   redis_name: :redixi,
#   redis_url: "redis://h:p3d58396416900fb1cbaa16337d7648243d0ee6e5ff2150b150bf4ab4041eea75@ec2-54-227-196-98.compute-1.amazonaws.com:25429"

config :inn_checker, InnChecker.Guardian,
  issuer: "inn_checker",
  secret_key: "P/SqaEhQQgdm1+XjDlPkZf5a1F4Jr+/olo61QnoCTuTlufLp1PmaXIwEcZ3o75ds"

# Configures the endpoint
config :inn_checker, InnCheckerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "EgrHW9Iq8tSKxKcAcLrxEl71LenIlZS71NpRmTXfv4nCbuvMLVUVYb0Za5zI3Ukh",
  render_errors: [view: InnCheckerWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: InnChecker.PubSub,
  live_view: [signing_salt: "jREuQBYA"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
