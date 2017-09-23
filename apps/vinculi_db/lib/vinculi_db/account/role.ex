defmodule VinculiDb.Account.Role do
  use Ecto.Schema
  import Ecto
  import Ecto.Changeset
  import Ecto.Query

  @required_fields ~w(name)

  schema "roles" do
    field :name, :string
    has_many :role_permissions, VinculiDb.Account.RolePermission

    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params,  @required_fields)
    |> validate_required(Enum.map @required_fields, &String.to_atom/1)
    |> validate_length(:name, min: 3, max: 40)
  end
end