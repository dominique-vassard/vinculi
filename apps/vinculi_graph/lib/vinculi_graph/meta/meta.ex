defmodule VinculiGraph.Meta do
  @moduledoc """
    Metadata of the graph
  """
  alias VinculiGraph.Repo

  alias VinculiGraph.Meta.Graph

  def list_labels() do
    Repo.all(Graph.get_schema_cql())
    |> Graph.extract_node_labels()
  end
end