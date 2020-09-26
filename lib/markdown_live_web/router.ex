defmodule MarkdownLiveWeb.Router do
  use MarkdownLiveWeb, :router
  use Pow.Phoenix.Router

  # pipeline :protected do
  #   plug Pow.Plug.RequireAuthenticated,
  #     error_handler: Pow.Phoenix.PlugErrorHandler
  # end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    pow_routes()
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MarkdownLiveWeb do
    pipe_through :browser

    live "/", MarkdownLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", MarkdownLiveWeb do
  #   pipe_through :api
  # end
end
