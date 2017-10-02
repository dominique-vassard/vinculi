defmodule VinculiGraph.School do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  schema "school" do
    field :name, :string
  end
end