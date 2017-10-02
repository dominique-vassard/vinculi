defmodule VinculiGraph.Translation do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  schema "translsation" do
    field :title, :string
  end
end