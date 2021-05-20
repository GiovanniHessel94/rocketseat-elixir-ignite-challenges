defmodule GithubIntegrationWeb.RepositoriesView do
  use GithubIntegrationWeb, :view

  def render("user_repos.json", %{user_repos: repos}) do
    %{
      message: "User's repositories retrieved with success!",
      data: repos
    }
  end
end
