defmodule Phx.Plugs.CanonicalDomain do
  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, _options) do
    if not_canonical_domain?(conn.host) do
      conn
      |> put_status(:moved_permanently)
      |> Phoenix.Controller.redirect(external: canonical_domain())
      |> halt()
    else
      conn
    end
  end

  defp canonical_scheme() do
    PhxWeb.Endpoint.config(:url)[:scheme]
  end

  defp canonical_domain do
    "#{canonical_scheme()}://#{canonical_host()}"
  end

  defp canonical_host() do
    PhxWeb.Endpoint.config(:url)[:host]
  end

  defp not_canonical_domain?(host) do
    !Regex.match?(~r/(\Awww\.)?#{host}.*\z/i, canonical_host())
  end
end
