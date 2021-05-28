defmodule GithubIntegrationWeb.RepositoriesController do
  use GithubIntegrationWeb, :controller

  alias GithubIntegrationWeb.Auth.Guardian
  alias GithubIntegrationWeb.FallbackController

  action_fallback FallbackController

  def get_user_repos(conn, %{"username" => username}) do
    with {:ok, user_repos} <- GithubIntegration.get_user_repos(username),
         {:ok, new_token} <- Guardian.refresh_token(conn) do
      conn
      |> put_status(:ok)
      |> render("user_repos.json", user_repos: user_repos, new_token: new_token)
    end
  end
end
