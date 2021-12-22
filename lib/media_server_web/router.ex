defmodule MediaServerWeb.Router do
  use MediaServerWeb, :router

  import MediaServerWeb.UserAuth
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {MediaServerWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  scope "/", MediaServerWeb do
    pipe_through [:browser, :require_authenticated_user]

    live "/", HomeLive.Index, :index

    live "/sonarrs", SonarrLive.Index, :index
    live "/sonarrs/new", SonarrLive.Index, :new
    live "/sonarrs/:id/edit", SonarrLive.Index, :edit

    live "/series", SeriesLive.Index, :index
    live "/series/:serie", SeriesLive.Show, :show

    live "/libraries", LibraryLive.Index, :index
    live "/libraries/new", LibraryLive.Index, :new
    live "/libraries/:id/edit", LibraryLive.Index, :edit
    live "/libraries/:id", LibraryLive.Show, :show
    live "/libraries/:id/show/edit", LibraryLive.Show, :edit

    live "/files/:id", FileLive.Show, :show
    live "/files/:id/identify", IdentifyLive.Show, :show
    live_session :watch, root_layout: {MediaServerWeb.WatchView, "watch.html"} do
      live "/files/:id/watch", WatchLive.Show, :show
    end
    get "/files/:id/stream", StreamController, :show

    get "/settings", UserSettingsController, :edit
    put "/settings", UserSettingsController, :update
    delete "/logout", UserSessionController, :delete

    live_dashboard "/dashboard", metrics: MediaServerWeb.Telemetry
  end

  scope "/", MediaServerWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/login", UserSessionController, :new
    post "/login", UserSessionController, :create
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
