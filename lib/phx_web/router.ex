defmodule PhxWeb.Router do
  use PhxWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhxWeb do
    pipe_through :browser

    live "/", CounterLive, session: [:user_id]
    get "/hello", HelloController, :index
    get "/hello/:messenger", HelloController, :show
    # resources "/users", UserController
    live "/users", UserLive.Index
    live "/users/new", UserLive.New
    live "/users/:id", UserLive.Show
    live "/users/:id/edit", UserLive.Edit
    resources "/fd_feeds", FDFeedController
  end

  scope "/e" do
    pipe_through :browser
    live "/", MarkdownLiveWeb.MarkdownLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhxWeb do
  #   pipe_through :api
  # end
end
