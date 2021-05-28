defmodule GithubIntegration.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias Ecto.Changeset

  @derive {Jason.Encoder, only: [:id]}

  @params [:id, :password]

  @primary_key {:id, :binary_id, autogenerate: false}
  schema "users" do
    field :password, :string, virtual: true
    field :password_hash, :string
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @params)
    |> validate_required(@params)
    |> validate_length(:password, min: 6)
    |> put_password_hash()
  end

  defp put_password_hash(%Changeset{changes: %{password: password}, valid?: true} = changeset) do
    change(changeset, Pbkdf2.add_hash(password))
  end

  defp put_password_hash(changeset), do: changeset
end
