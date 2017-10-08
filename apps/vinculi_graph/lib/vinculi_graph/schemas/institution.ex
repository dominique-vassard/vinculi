defmodule VinculiGraph.Institution do
  use VinculiGraph.NodeSchema
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  schema "institution" do
    field :type, :string
    field :name, :string
  end
end