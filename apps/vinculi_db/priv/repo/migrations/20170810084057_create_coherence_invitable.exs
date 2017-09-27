defmodule VinculiDb.Repo.Migrations.CreateCoherenceInvitable do
  use Ecto.Migration
  def change do
    create table(:invitations) do

      add :name, :string, null: false
      add :email, :string, null: false
      add :token, :string
      timestamps()
    end
    create unique_index(:invitations, [:email])
    create index(:invitations, [:token])

  end
end
