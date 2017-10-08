defmodule VinculiGraph.Meta do
  @moduledoc """
    Metadata of the graph
  """

  alias VinculiGraph.Meta.Graph
  alias VinculiGraph.Repo

  @doc """
    Retrieves all labels used in database.

    ## Example:
        iex> VinculiGraph.Meta.list_labels()
        ["Continent", "Country", "Degree", "Domain", "Institution",
            "Language", "Person", "Profession", "Publication", "School", "Town",
            "Translation", "Year"]
  """
  def list_labels() do
    Repo.all(Graph.get_schema_cql())
    |> Graph.extract_node_labels()
  end
end