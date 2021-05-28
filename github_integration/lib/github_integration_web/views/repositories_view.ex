defmodule GithubIntegrationWeb.RepositoriesView do
  use GithubIntegrationWeb, :view

  def render("user_repos.json", %{user_repos: repos, new_token: new_token}) do
    %{
      data: repos,
      message: "User's repositories retrieved with success!",
      new_token: new_token
    }
  end
end
