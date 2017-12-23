defmodule VinculiGraph.Meta.Relationship do
  @moduledoc """
  Contains functions related to query constrtction for node
  """

  @doc """
  Returns cypher query to retrieve all node labels

  ### Example

      iex> VinculiGraph.Meta.Relationship.get_types_cql()
      "CALL db.relationshipTypes()"
  """
  def get_types_cql() do
    "CALL db.relationshipTypes()"
  end

end