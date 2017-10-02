defmodule VinculiGraph.Year do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  schema "year" do
    field :value, :string
  end
end