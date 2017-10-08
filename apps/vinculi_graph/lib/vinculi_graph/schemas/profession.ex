defmodule VinculiGraph.Profession do
  use VinculiGraph.NodeSchema
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  schema "profession" do
    field :name, :string
  end
end