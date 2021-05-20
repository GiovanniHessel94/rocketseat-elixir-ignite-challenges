defmodule GithubIntegration.Repositories.Client do
  use Tesla

  plug Tesla.Middleware.JSON

  alias GithubIntegration.Error

  alias Tesla.Env

  @base_url "https://api.github.com/users/"
  @max_per_page 100

  def get_user_repos(base_url \\ @base_url, username), do: do_get_user_repos(base_url, username)

  defp do_get_user_repos(base_url, page \\ 1, repos \\ [], username) do
    url = "#{base_url}#{username}/repos?page=#{page}&per_page=#{@max_per_page}&sort=updated"

    with {:ok, %Env{status: 200, body: body}} <- get(url),
         length_is_equal_to_max <- body_length_is_equal_to_max(body) do
      case length_is_equal_to_max do
        false -> format_response(repos ++ body)
        true -> do_get_user_repos(base_url, page + 1, repos ++ body, username)
      end
    else
      {:ok, %Env{status: 404, body: _body}} ->
        {:error, Error.build(:not_found, "User not found!")}

      _error ->
        {:error, Error.build(:service_unavailable, "Service unavailable!")}
    end
  end

  defp body_length_is_equal_to_max(body) when length(body) === @max_per_page, do: true
  defp body_length_is_equal_to_max(_body), do: false

  defp format_response(body), do: {:ok, Enum.map(body, &get_repo_info/1)}

  defp get_repo_info(repo) do
    %{
      id: repo["id"],
      name: repo["name"],
      description: repo["description"],
      html_url: repo["html_url"],
      stargazers_count: repo["stargazers_count"]
    }
  end
end
