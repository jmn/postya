# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :phx,
  ecto_repos: [Phx.Repo]

# Configures the endpoint
config :phx, PhxWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "n9Y9czH1dwIJQeV0+XeLuoe3J2o5IemhzVZaUJ6rXEUVnn5URPmLPsASsC4IDhzf",
  render_errors: [view: PhxWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Phx.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "6nt6/L3OuKLZ1zA1QXXU3LCk7xEk94pM"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phx, Phx.UserManager.Guardian,
  issuer: "phx",
  secret_key: "hfE+D5ZfAA+c88w1hphCgmLbzp0JxZDVa5bEZocNPsS6/CgEONEDHpvZGfuplUTj"

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
