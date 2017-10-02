defmodule VinculiGraph.Domain do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  schema "domain" do
    field :name, :string
  end
end