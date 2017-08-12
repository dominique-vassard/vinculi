defmodule ArsMagica.Taxonomy do
  @moduledoc """
    Access to Ars Magica taxonomy data
  """

  use Ecto.Schema

  schema "taxonomy_term_data" do
    field :tid, :integer
    field :vid, :integer
    field :name, :string
    field :description, :string
    field :format, :string
    field :weight, :integer
  end

  @doc """
  Return the taxonomy data for the given id
  """
  def get(id) do
    query = "SELECT tid, name FROM taxonomy_term_data WHERE tid = ?"
    Ecto.Adapters.SQL.query!(ArsMagica.Repo, query, [id])
  end
end