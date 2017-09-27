defmodule VinculiDb.Account.Permission do
  use Ecto.Schema
  import Ecto.Changeset

  alias VinculiDb.Account.Role
  alias VinculiDb.Account.RolePermission

  @required_fields ~w(name)

  schema "permissions" do
    field :name, :string
    many_to_many :roles, Role, join_through: RolePermission, on_replace: :delete

    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params,  @required_fields)
    |> validate_required(Enum.map @required_fields, &String.to_atom/1)
    |> validate_length(:name, min: 3, max: 40)
  end
end