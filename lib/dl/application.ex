defmodule Dl.Application do
  use Application

  def start(_type, _args) do
    Dl.run()

    children = [
      # Starts a worker by calling: Dl.Worker.start_link(arg)
      # {Dl.Worker, arg}
      {Dl.Repo, []},
      {Dl.Sched, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dl.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
