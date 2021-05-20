defmodule GithubIntegrationWeb.FallbackController do
  use GithubIntegrationWeb, :controller

  alias GithubIntegration.Error

  alias GithubIntegrationWeb.ErrorView

  def call(conn, {:error, %Error{status: status, result: result}}) do
    conn
    |> put_status(status)
    |> put_view(ErrorView)
    |> render("error.json", result: result)
  end

  def call(conn, _error) do
    conn
    |> put_status(:internal_server_error)
    |> put_view(ErrorView)
    |> render("error.json", result: "An error has occurred!")
  end
end
