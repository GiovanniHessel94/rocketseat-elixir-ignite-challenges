defmodule GithubIntegration do
  alias GithubIntegration.Repositories.Client, as: RepositoriesClient

  alias GithubIntegration.Users.Create, as: UsersCreate
  alias GithubIntegration.Users.Get, as: UsersGet

  defdelegate get_user_repos(username), to: RepositoriesClient, as: :get_user_repos

  defdelegate create_user(params), to: UsersCreate, as: :call
  defdelegate get_user_by_id(id), to: UsersGet, as: :by_id
end
