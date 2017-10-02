defmodule VinculiGraph.Profession do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  schema "profession" do
    field :name, :string
  end
end