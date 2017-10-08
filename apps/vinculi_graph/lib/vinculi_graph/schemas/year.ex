defmodule VinculiGraph.Year do
  use VinculiGraph.NodeSchema
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  schema "year" do
    field :value, :string
  end

  def get_name_fields() do
    [:value]
  end
end