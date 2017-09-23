defmodule VinculiDb.Account.RolePermission do
  use Ecto.Schema

  schema "role_permissions" do
    belongs_to :role, VinculiDb.Account.Role
    belongs_to :permission, VinculiDb.Account.Permission

    timestamps();
  end
end