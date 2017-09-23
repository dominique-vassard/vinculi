defmodule VinculiDb.Repo.Migrations.AddRoles do
  use Ecto.Migration

  def change do
    # Permissions table
    create table(:permissions) do
      add :name, :string

      timestamps()
    end

    # Roles table
    create table(:roles) do
      add :name, :string

      timestamps()
    end

    # Permission to role table
    create table(:role_permissions) do
      add :role_id, references(:roles, on_delete: :delete_all,
                               on_update: :update_all)
      add :permission_id, references(:permissions, on_delete: :delete_all,
                                     on_update: :update_all)

      timestamps()
    end

    # Add role to users table
    alter table(:users) do
      add :role_id, references(:roles, on_delete: :nilify_all,
                               on_update: :update_all)
    end
  end
end
