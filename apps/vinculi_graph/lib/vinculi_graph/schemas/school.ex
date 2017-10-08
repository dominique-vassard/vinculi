defmodule VinculiGraph.School do
  use VinculiGraph.NodeSchema
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  schema "School" do
    field :name, :string
  end
end