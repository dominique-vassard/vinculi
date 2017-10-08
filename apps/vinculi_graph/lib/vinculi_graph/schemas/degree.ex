defmodule VinculiGraph.Degree do
  use VinculiGraph.NodeSchema
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  schema "Degree" do
    field :name, :string
  end
end