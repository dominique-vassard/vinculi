defmodule VinculiDb.Repo.Migrations.AddRoles do
  use Ecto.Migration

  def change do
    # Permissions table
    create table(:permissions) do
      add :name, :string, null: false

      timestamps()
    end

    # Permission name should be unique
    create unique_index(:permissions, :name)

    # Roles table
    create table(:roles) do
      add :name, :string, null: false

      timestamps()
    end

    # Role name should be unique
    create unique_index(:roles, :name)

    # Permission to role table
    create table(:role_permissions, primary_key: false) do
      add :role_id, references(:roles, on_delete: :delete_all,
                               on_update: :update_all), null: false
      add :permission_id, references(:permissions, on_delete: :delete_all,
                                     on_update: :update_all), null: false

      timestamps()
    end

    # Role <-> permission association should be unique
    create unique_index(:role_permissions, [:role_id, :permission_id])

    # Add role to users table
    alter table(:users) do
      add :role_id, references(:roles, on_delete: :nilify_all,
                               on_update: :update_all), null: false
    end
  end
end
