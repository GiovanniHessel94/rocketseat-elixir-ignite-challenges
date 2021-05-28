defmodule GithubIntegrationWeb.Router do
  use GithubIntegrationWeb, :router

  alias GithubIntegrationWeb.Auth.Pipeline

  alias GithubIntegrationWeb.Plugs.UUIDChecker

  pipeline :api do
    plug :accepts, ["json"]
    plug UUIDChecker
  end

  pipeline :auth do
    plug Pipeline
  end

  scope "/api", GithubIntegrationWeb do
    pipe_through :api

    post "/users", UsersController, :create
    post "/users/login", UsersController, :login
  end

  scope "/api", GithubIntegrationWeb do
    pipe_through :auth

    get "/users/:username/repos", RepositoriesController, :get_user_repos
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: GithubIntegrationWeb.Telemetry
    end
  end
end
