defmodule VinculiDb.Repo.Migrations.ReAddName do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :name, :string
    end

    alter table(:invitations) do
      add :name, :string
    end
  end
end
