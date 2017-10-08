defmodule VinculiGraph.Town do
  use VinculiGraph.NodeSchema
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  schema "Town" do
    field :name, :string
    field :lat, :float
    field :long, :float
  end
end