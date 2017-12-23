defmodule VinculiGraph.Relationship do
  @moduledoc """
  Functions for graph operations on Node.
  """
  alias VinculiGraph.Repo
  alias VinculiGraph.Meta.Relationship

  @doc """
  Return all relationship types used in database.

  ### Example

      iex> VinculiGraph.Relationship.get_types()
      ["IS_IN_COUNTRY", "IS_IN_CONTINENT", "WHERE_BORN", "WHEN_BORN", "WHERE_DIED",
       "WHEN_DIED", "WROTE", "WHEN_WRITTEN", "IS_OF_DOMAIN", "IS_OF_SCHOOL",
       "HAS_ORIGINAL_LANGUAGE", "HAS_DEGREE", "DEGREE_FROM", "HAS_PROFESSION",
       "EMPLOYED_BY", "EMPLOYED_FROM", "EMPLOYED_TO", "TRANSLATED",
       "TRANSLATED_IN_LANGUAGE", "WHEN_TRANSLATED", "CO_WROTE", "INFLUENCED"]
  """
  def get_types() do
    Repo.all(Relationship.get_types_cql())
    |> Enum.map(fn %{"relationshipType" => type} -> type end)
  end
end