defmodule GithubIntegrationWeb.UsersView do
  use GithubIntegrationWeb, :view

  alias GithubIntegration.User

  def render("created.json", %{user: %User{} = user}) do
    %{
      message: "User created with success!",
      user: user
    }
  end

  def render("login.json", %{token: token}) do
    %{
      token: token
    }
  end
end
