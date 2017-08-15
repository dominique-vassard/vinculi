defmodule VinculiDb.Repo.Migrations.AddFirstAndLastName do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :name
      add :first_name, :string
      add :last_name, :string
    end

    alter table(:invitations) do
      remove :name
      add :first_name, :string
      add :last_name, :string
    end
  end
end
