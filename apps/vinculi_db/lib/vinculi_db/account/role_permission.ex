defmodule VinculiDb.Account.RolePermission do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(role_id, permission_id)

  @primary_key false
  schema "role_permissions" do
    belongs_to :role, VinculiDb.Account.Role
    belongs_to :permission, VinculiDb.Account.Permission

    timestamps();
  end

  # def changeset(struct, params \\ %{}) do
  #   struct
  #   |> cast(params, [:role_id, :permission_id])
  #   |> validate_required([])
  # end
end