defmodule MealsMonitor.Meal do
  use Ecto.Schema

  import Ecto.Changeset

  @params [:descricao, :data, :calorias]

  @derive {Jason.Encoder, only: [:id, :descricao, :data, :calorias]}

  schema "meals" do
    field :descricao, :string, source: :description
    field :data, :naive_datetime, source: :date
    field :calorias, :decimal, source: :calories
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @params)
    |> validate_required(@params)
    |> validate_length(:descricao, max: 100)
    |> validate_number(:calorias, less_than_or_equal_to: 100_000)
  end
end
