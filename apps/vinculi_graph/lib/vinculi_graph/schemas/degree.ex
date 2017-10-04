defmodule VinculiGraph.Degree do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  schema "degree" do
    field :name, :string
  end
end