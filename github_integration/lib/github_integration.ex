defmodule GithubIntegration do
  alias GithubIntegration.Repositories.Client, as: RepositoriesClient

  defdelegate get_user_repos(username), to: RepositoriesClient, as: :get_user_repos
end
