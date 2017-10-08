defmodule VinculiGraph.Person do
  use VinculiGraph.NodeSchema
  use Ecto.Schema

    @primary_key {:uuid, :binary_id, autogenerate: true}
    schema "Person" do
      field :firstName, :string
      field :lastName, :string
      field :aka, :string
      field :internalLink, :string
      field :externalLink, :string
    end

    def get_name_fields() do
      [:firstName, :lastName]
    end
end