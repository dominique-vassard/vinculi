defmodule VinculiGraph.Degree do
  use VinculiGraph.NodeSchema
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  schema "degree" do
    field :name, :string
  end
end