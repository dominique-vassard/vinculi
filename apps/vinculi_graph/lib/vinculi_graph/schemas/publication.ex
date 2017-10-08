defmodule VinculiGraph.Publication do
  use VinculiGraph.NodeSchema
  use Ecto.Schema

    @primary_key {:uuid, :binary_id, autogenerate: true}
    schema "Publication" do
      field :type, :string
      field :title, :string
      field :titleFr, :string
      field :internalLink, :string
      field :externalLink, :string
    end

    def get_name_fields() do
      [:titleFr]
    end
end