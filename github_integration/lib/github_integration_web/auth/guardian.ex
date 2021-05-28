defmodule GithubIntegrationWeb.Auth.Guardian do
  use Guardian, otp_app: :github_integration

  alias GithubIntegration.{Error, User}

  alias Plug.Conn

  def subject_for_token(%User{id: id}, _claims) do
    {:ok, id}
  end

  def resource_from_claims(claims) do
    claims
    |> Map.get("sub")
    |> GithubIntegration.get_user_by_id()
  end

  def authenticate(%{"id" => id, "password" => password}) do
    with {:ok, %User{password_hash: hash} = user} <- GithubIntegration.get_user_by_id(id),
         true <- Pbkdf2.verify_pass(password, hash),
         {:ok, token, _claims} <- encode_and_sign(user, %{}, ttl: {1, :minute}) do
      {:ok, token}
    else
      false -> {:error, Error.build(:unauthorized, "Invalid credentials!")}
      {:error, _reason} = error -> error
    end
  end

  def authenticate(_), do: {:error, Error.build(:unauthorized, "Invalid credentials!")}

  def refresh_token(%Conn{} = conn) do
    conn
    |> Conn.get_req_header("authorization")
    |> split_bearer()
    |> do_refresh_token()
  end

  defp split_bearer([bearer_token]), do: String.split(bearer_token, " ")

  defp do_refresh_token([_bearer, token]) do
    {:ok, _old_stuff, {new_token, _new_claims}} = refresh(token, ttl: {1, :minute})

    {:ok, new_token}
  end
end
