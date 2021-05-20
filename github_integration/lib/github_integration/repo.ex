defmodule GithubIntegration.Repo do
  use Ecto.Repo,
    otp_app: :github_integration,
    adapter: Ecto.Adapters.Postgres
end
