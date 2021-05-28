defmodule GithubIntegrationWeb.UsersController do
  use GithubIntegrationWeb, :controller

  alias GithubIntegrationWeb.Auth.Guardian
  alias GithubIntegrationWeb.FallbackController

  action_fallback FallbackController

  def create(conn, params) do
    with {:ok, user} <- GithubIntegration.create_user(params) do
      conn
      |> put_status(:created)
      |> render("created.json", user: user)
    end
  end

  def login(conn, params) do
    with {:ok, token} <- Guardian.authenticate(params) do
      conn
      |> put_status(:ok)
      |> render("login.json", token: token)
    end
  end
end
