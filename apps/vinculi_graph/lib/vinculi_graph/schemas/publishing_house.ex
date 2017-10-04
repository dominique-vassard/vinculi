defmodule VinculiGraph.PublishingHouse do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  schema "publishing_house" do
    field :name, :string
  end
end