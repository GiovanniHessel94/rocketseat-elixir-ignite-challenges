defmodule GithubIntegration.Users.Create do
  alias Ecto.{Changeset, UUID}

  alias GithubIntegration.{Error, Repo, User}

  def call(params) do
    params = Map.put(params, "id", UUID.generate())

    with %Changeset{valid?: true} = changeset <- User.changeset(params),
         {:ok, _user} = result <- Repo.insert(changeset) do
      result
    else
      %Changeset{} = changeset -> {:error, Error.build(:bad_request, changeset)}
      {:error, %Error{}} = error -> error
    end
  end
end
