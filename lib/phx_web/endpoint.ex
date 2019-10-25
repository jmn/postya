defmodule PhxWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :phx

  # makes the /metrics URL happen
   plug Phx.PrometheusExporter
  # measures pipeline exec times
   plug Phx.PipelineInstrumenter

  plug Plug.Session,
    store: :cookie,
    key: "_phx_key",
    signing_salt: "secret"

  plug Pow.Plug.Session, otp_app: :phx
  plug PowPersistentSession.Plug.Cookie

  if Mix.env() == :prod do
    plug Phx.Plugs.WWWRedirect
    plug(:canonical_host)
  end

  defp canonical_host(conn, _opts) do
    :phx
    |> Application.get_env(:canonical_host)
    |> case do
      host when is_binary(host) ->
        opts = PlugCanonicalHost.init(canonical_host: host)
        PlugCanonicalHost.call(conn, opts)

      _ ->
        conn
    end
  end

  socket "/live", Phoenix.LiveView.Socket

  socket "/socket", PhxWeb.UserSocket,
    websocket: true,
    longpoll: false

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :phx,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_phx_key",
    signing_salt: "OB7Tbjj1"

  plug PhxWeb.Router
end
