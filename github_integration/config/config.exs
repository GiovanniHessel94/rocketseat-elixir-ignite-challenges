# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :github_integration,
  ecto_repos: [GithubIntegration.Repo]

# Configures the endpoint
config :github_integration, GithubIntegrationWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "DneL7W28SMFMWeZunbymUybOCRlADYdhcWJ5xqs6+RVfJwOUqgPTHjpmeS7q5vQK",
  render_errors: [view: GithubIntegrationWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: GithubIntegration.PubSub,
  live_view: [signing_salt: "DkRahR4r"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configures the tesla's adapter
config :tesla, adapter: Tesla.Adapter.Hackney

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
