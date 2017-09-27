# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     VinculiWeb.Repo.insert!(%VinculiWeb.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias VinculiDb.Repo
import Ecto.Query

alias VinculiDb.Account.Permission
alias VinculiDb.Account.RolePermission
alias VinculiDb.Account.Role

# Data to insert
role_permissions = [
  %{role: "Administrator", permissions: ["Administer", "Read", "Write", "Validate"]},
  %{role: "Reader", permissions: ["Read"]},
  %{role: "Writer", permissions: ["Read", "Write"]},
  %{role: "Validator", permissions: ["Read", "Write", "Validate"]}
]

for role_perm <- role_permissions do
  %{role: role, permissions: all_permissions}  = role_perm

  # Feed role table
  unless Repo.get_by Role, name: role do
    Repo.insert! %Role{name: role}
  end

  # Get all roles
  query = from p in Role, select: map(p, [:id, :name])
  roles = Repo.all(query)

  for permission <- all_permissions do
    # Feed permissions table
    unless Repo.get_by Permission, name: permission do
      Repo.insert! %Permission{name: permission}
    end

    # Get all permissions
    query = from p in Permission, select: map(p, [:id, :name])
    permissions = Repo.all(query)

    # Feed role_permissions table
    %{id: role_id} = Enum.find roles, fn(x) -> x[:name] == role end
    %{id: permission_id} = Enum.find permissions, fn(x) -> x[:name] == permission end
    unless Repo.get_by RolePermission, %{role_id: role_id, permission_id: permission_id} do
      Repo.insert! %RolePermission{role_id: role_id, permission_id: permission_id}
    end
  end
end
