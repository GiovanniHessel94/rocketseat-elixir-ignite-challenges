defmodule GithubIntegration.Repositories.ClientTest do
  use ExUnit.Case, async: true

  alias GithubIntegration.Error
  alias GithubIntegration.Repositories.Client

  alias Plug.Conn

  describe "get_user_repos/1" do
    setup do
      bypass = Bypass.open()

      {:ok, bypass: bypass}
    end

    test "when the user exists and has repositories, return the repositories", %{bypass: bypass} do
      username = "username"

      url = endpoint_url(bypass.port)

      body = ~s([
        {
          "description":
            "This repository will be used to display all the projects that will be developed in the Ignite - Elixir #NeverStopLearning ",
          "html_url": "https://github.com/ZickkyG/ignite-projects",
          "id": "347.659.525",
          "name": "ignite-projects",
          "stargazers_count": 0
        },
        {
          "description":
            "This repository will be used to display all the challenges that will be developed in the Ignite - Elixir #NeverStopLearning",
          "html_url": "https://github.com/ZickkyG/ignite-challenges",
          "id": "346.497.884",
          "name": "ignite-challenges",
          "stargazers_count": 0
        }
      ])

      Bypass.expect(
        bypass,
        "GET",
        "#{username}/repos",
        fn conn ->
          conn
          |> Conn.put_resp_header("content-type", "application/json")
          |> Conn.resp(200, body)
        end
      )

      response = Client.get_user_repos(url, username)

      expected_response =
        {:ok,
         [
           %{
             description:
               "This repository will be used to display all the projects that will be developed in the Ignite - Elixir #NeverStopLearning ",
             html_url: "https://github.com/ZickkyG/ignite-projects",
             id: "347.659.525",
             name: "ignite-projects",
             stargazers_count: 0
           },
           %{
             description:
               "This repository will be used to display all the challenges that will be developed in the Ignite - Elixir #NeverStopLearning",
             html_url: "https://github.com/ZickkyG/ignite-challenges",
             id: "346.497.884",
             name: "ignite-challenges",
             stargazers_count: 0
           }
         ]}

      assert response === expected_response
    end

    test "when the don't exists, return an error", %{bypass: bypass} do
      username = "not_found"

      url = endpoint_url(bypass.port)

      Bypass.expect(
        bypass,
        "GET",
        "#{username}/repos",
        fn conn ->
          conn
          |> Conn.resp(404, "")
        end
      )

      response = Client.get_user_repos(url, username)

      expected_response = {:error, %Error{result: "User not found!", status: :not_found}}

      assert response === expected_response
    end

    test "when an generic error occur, return an error", %{bypass: bypass} do
      username = "not_found"

      url = endpoint_url(bypass.port)

      Bypass.down(bypass)

      response = Client.get_user_repos(url, username)

      expected_response =
        {:error, %Error{result: "Service unavailable!", status: :service_unavailable}}

      assert response === expected_response
    end
  end

  defp endpoint_url(port), do: "http://localhost:#{port}/"
end
