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
  pubsub_server: Phx.PubSub,
  live_view: [
    signing_salt: "6nt6/L3OuKLZ1zA1QXXU3LCk7xEk94pM"
  ],
  version: Mix.Project.config[:version],
  http: [
    compress: true,
    protocol_options: [max_keepalive: 5_000_000]
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

config :prometheus, Phx.PhoenixInstrumenter,
  controller_call_labels: [:controller, :action],
  duration_buckets: [
    10,
    25,
    50,
    100,
    250,
    500,
    1000,
    2500,
    5000,
    10_000,
    25_000,
    50_000,
    100_000,
    250_000,
    500_000,
    1_000_000,
    2_500_000,
    5_000_000,
    10_000_000
  ],
  registry: :default,
  duration_unit: :microseconds

config :prometheus, Phx.PipelineInstrumenter,
  labels: [:status_class, :method, :host, :scheme, :request_path],
  duration_buckets: [
    10,
    100,
    1_000,
    10_000,
    100_000,
    300_000,
    500_000,
    750_000,
    1_000_000,
    1_500_000,
    2_000_000,
    3_000_000
  ],
  registry: :default,
  duration_unit: :microseconds

config :kernel,
  inet_dist_listen_min: 9001,
  inet_dist_listen_max: 9001

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
