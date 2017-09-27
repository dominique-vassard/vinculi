defmodule VinculiDb.Repo.Migrations.AddFirstAndLastName do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :name
      add :first_name, :string, null: false
      add :last_name, :string, null: false
    end

    alter table(:invitations) do
      remove :name
      add :first_name, :string, null: false
      add :last_name, :string, null: false
    end
  end
end
