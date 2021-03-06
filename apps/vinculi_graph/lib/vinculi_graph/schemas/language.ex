defmodule VinculiGraph.Language do
  use VinculiGraph.NodeSchema
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  schema "Language" do
    field :name, :string
  end
end