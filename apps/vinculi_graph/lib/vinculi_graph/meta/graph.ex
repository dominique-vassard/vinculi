defmodule VinculiGraph.Meta.Graph do
  @moduledoc """
  Contains meta graph related functions
  """

  @doc """
  Returns cql to get database metadata (nodes,realtionships, properties)

  ### Example
      iex> VinculiGraph.Meta.Graph.get_schema_cql()
      "CALL db.schema()"
  """
  def get_schema_cql() do
    "CALL db.schema()"
  end

  @doc """
  Extract node labels from `CALL db.schema()`result

  Returns a list of node labels
  """
  def extract_node_labels([%{"nodes" => nodes}] = _schema) do
    nodes
    |> Enum.map(fn n -> n.labels end)
    |> List.flatten()
    |> Enum.sort()
  end
end