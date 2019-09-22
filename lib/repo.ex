defmodule Dl.Repo do
  use Ecto.Repo, otp_app: :scrappy, adapter: Ecto.Adapters.Postgres
end