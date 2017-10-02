defmodule VinculiGraph.Continent do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  schema "continent" do
    field :name, :string
    field :lat, :float
    field :long, :float
  end
end