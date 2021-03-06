defmodule Phx.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    require Prometheus.Registry

    Phx.PhoenixInstrumenter.setup()
    Phx.PipelineInstrumenter.setup()
    # Phx.RepoInstrumenter.setup()
    Prometheus.Registry.register_collector(:prometheus_process_collector)
    Phx.PrometheusExporter.setup()
    Phx.Metrics.setup()


    children = [
      # Start the Ecto repository
      Phx.Repo,

      # Concurrently download feeds
      Dl.Sched,

      # Start Phoenix PubSub
      {Phoenix.PubSub, [name: Phx.PubSub, adapter: Phoenix.PubSub.PG2]},

      # Telemetry for /stats
      PhxWeb.Telemetry,

      # Start the endpoint when the application starts
      PhxWeb.Endpoint
      # Starts a worker by calling: Phx.Worker.start_link(arg)
      # {Phx.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Phx.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PhxWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
