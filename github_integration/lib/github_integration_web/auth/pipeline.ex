defmodule GithubIntegrationWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline, otp_app: :github_integration

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
