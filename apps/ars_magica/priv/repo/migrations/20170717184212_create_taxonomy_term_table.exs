defmodule ArsMagica.Repo.Migrations.CreateTaxonomyTermTable do
  use Ecto.Migration

  def change do
    create table(:taxonomy_term_data) do
      add :tid, :integer
      add :vid, :integer
      add :name, :string
      add :description, :string
      add :format, :string
      add :weight, :integer
    end
  end
end
