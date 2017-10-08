defmodule VinculiGraph.Publication do
  use VinculiGraph.NodeSchema
  use Ecto.Schema

    @primary_key {:uuid, :binary_id, autogenerate: true}
    schema "Publication" do
      field :type, :string
      field :title, :string
      field :title_fr, :string
      field :internal_link, :string
      field :external_link, :string
    end

    def get_name_fields() do
      [:title_fr]
    end
end