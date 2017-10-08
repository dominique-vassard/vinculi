defmodule VinculiGraph.PublishingHouse do
  use VinculiGraph.NodeSchema
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  schema "PublishingHouse" do
    field :name, :string
  end
end