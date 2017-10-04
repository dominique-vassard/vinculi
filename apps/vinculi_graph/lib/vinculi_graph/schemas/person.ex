defmodule VinculiGraph.Person do
  use Ecto.Schema

    @primary_key {:uuid, :binary_id, autogenerate: true}
    schema "person" do
      field :first_name, :string
      field :last_name, :string
      field :aka, :string
      field :internal_link, :string
      field :external_link, :string
    end
end