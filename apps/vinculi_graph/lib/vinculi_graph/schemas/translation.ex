defmodule VinculiGraph.Translation do
  use VinculiGraph.NodeSchema
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  schema "Translsation" do
    field :title, :string
  end

  def get_name_fields() do
    [:title]
  end
end