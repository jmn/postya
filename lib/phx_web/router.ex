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

  # Our pipeline implements "maybe" authenticated. We'll use the `:ensure_auth` below for when we need to make sure someone is logged in.
  pipeline :auth do
    plug Phx.UserManager.Pipeline
  end

  # We use ensure_auth to fail if there is no one logged in
  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", PhxWeb do
    pipe_through [:browser, :auth]

    live "/", CounterLive, session: [:user_id]
    get "/hello", HelloController, :index
    get "/hello/:messenger", HelloController, :show
    # resources "/users", UserController
    resources "/fd_feeds", FDFeedController
    # resources "/posts", PostController
    get "/login", SessionController, :new
    post "/login", SessionController, :login
    get "/logout", SessionController, :logout
    get "/posts/:id", PostController, :show
    get "/posts", PostController, :index
    get "/posts/new", PostController, :new
  end

  scope "/", PhxWeb do
    pipe_through [:browser, :auth, :ensure_auth]
    delete "/posts/:id", PostController, :delete
    get "/posts/:id/edit", PostController, :edit
    get "/protected", PageController, :protected
  end

  scope "/e" do
    pipe_through [:browser, :auth, :ensure_auth]
    live "/", MarkdownLiveWeb.MarkdownLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhxWeb do
  #   pipe_through :api
  # end
end
