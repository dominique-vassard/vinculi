defmodule VinculiGraph.Domain do
  use VinculiGraph.NodeSchema
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  schema "Domain" do
    field :name, :string
  end
end