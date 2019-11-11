defmodule PhxWeb.Router do
  use PhxWeb, :router
  use Pow.Phoenix.Router
  use Pow.Extension.Phoenix.Router, otp_app: :phx

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

  pipeline :admin do
    plug PhxWeb.EnsureRolePlug, :admin
  end

  scope "/" do
    pipe_through [:browser]
    pow_routes()
    pow_extension_routes()
  end

  scope "/", PhxWeb do
    pipe_through [:browser, :admin]

    get "/posts/new", PostController, :new
    post "/posts/new", PostController, :create
    delete "/posts/:id", PostController, :delete
    get "/posts/:id/edit", PostController, :edit
    put "/posts/:id/edit", PostController, :update
  end

  scope "/", PhxWeb do
    pipe_through [:browser]

    live "/", CounterLive, session: [:user_id]
    resources "/fd_feeds", FDFeedController
    get "/posts/:id", PostController, :show
    get "/posts", PostController, :index
    resources "/chat", ChatController
  end

  scope "/e" do
    pipe_through [:browser]
    live "/", MarkdownLiveWeb.MarkdownLive
  end

end
