defmodule Phx.MixProject do
  use Mix.Project

  def project do
    [
      app: :phx,
      version: System.get_env("BUILD_VERSION") || "0.1.6",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      releases: [
        phx: [
          include_executables_for: [:unix],
          applications: [runtime_tools: :permanent]
        ],
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Phx.Application, []},
      extra_applications: [:logger, :runtime_tools, :observer, :wx, :debugger, :os_mon]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.7"},
      {:phoenix_pubsub, "~> 2.0"},
      {:phoenix_ecto, "~> 4.2"},
      {:ecto_sql, "~> 3.5"},
      {:ecto_psql_extras, "~> 0.4.2"},
      {:postgrex, "~> 0.15.7"},
      {:phoenix_html, "~> 2.14"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.18"},
      {:jason, "~> 1.1"},
      {:plug_cowboy, "~> 2.4"},
      {:phoenix_live_view, "~> 0.15"},
      {:phoenix_live_dashboard, "~> 0.4.0"},
      {:floki, ">= 0.0.0", only: :test},
      {:httpoison, "~> 1.5"},
      {:progress_bar, "> 0.0.0"},
      {:elixir_feed_parser, github: "jmn/elixir-feed-parser", branch: "master"},
      {:flow, "~> 1.1"},
      {:html_sanitize_ex, "~> 1.4.1"},
      {:paginator, "~> 1.0"},
      {:earmark, "~> 1.3"},
      {:ecto_autoslug_field, "~> 2.0"},
      {:plug_canonical_host, "~> 2.0"},
      {:observer_cli, "~> 1.5"},
      {:prometheus_ex, "~> 3.0.5"},
      # {:prometheus_ecto, "~> 1.4.1"},
      {:prometheus_phoenix, "~> 1.3.0"},
      {:prometheus_plugs, "~> 1.1.1"},
      {:prometheus_process_collector, "~> 1.4.5"},
      {:hackney, "~> 1.15.2"},
      {:swoosh, "~> 0.23"},
      {:pow, "~> 1.0.21"},
      {:telemetry_poller, "~> 0.4"},
      {:telemetry_metrics, "~> 0.4"},
      {:sentry, "~> 8.0"},
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
