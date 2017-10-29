defmodule VinculiGraph.Format.Cytoscape do
  @moduledoc """
  Format a Bolt.Sips query result in a cytoscape-compliant structure
  """
  alias Bolt.Sips.Types.Relationship
  alias Bolt.Sips.Types.Node

  @doc """
  Format a query result to cytoscape format.

  `data` should be a list of maps.

  #### Example

    iex> query_result = [%{"neighbour" => %Bolt.Sips.Types.Node{id: 2415, labels: ["Person"],
      properties: %{"firstName" => "Marcel", "lastName" => "MAUSS",
        "uuid" => "person-9"}},
     "relation" => %Bolt.Sips.Types.Relationship{end: 2415, id: 1432,
      properties: %{"strength" => 2}, start: 2373, type: "INFLUENCED"},
     "source" => %Bolt.Sips.Types.Node{id: 2373, labels: ["Person"],
      properties: %{"externalLink" => "https://en.wikipedia.org/wiki/David_Hume",
        "firstName" => "David",
        "internalLink" => "http://arsmagica.fr/polyphonies/hume-david-1711-1776",
        "lastName" => "HUME", "uuid" => "person-1"}}},
    %{"neighbour" => %Bolt.Sips.Types.Node{id: 2398, labels: ["Person"],
      properties: %{"firstName" => "Edmund", "lastName" => "HUSSERL",
        "uuid" => "person-6"}},
     "relation" => %Bolt.Sips.Types.Relationship{end: 2398, id: 1429,
      properties: %{"strength" => 2}, start: 2373, type: "INFLUENCED"},
     "source" => %Bolt.Sips.Types.Node{id: 2373, labels: ["Person"],
      properties: %{"externalLink" => "https://en.wikipedia.org/wiki/David_Hume",
        "firstName" => "David",
        "internalLink" => "http://arsmagica.fr/polyphonies/hume-david-1711-1776",
        "lastName" => "HUME", "uuid" => "person-1"}}}]

    iex> VinculiGraph.Format.Cytoscape.format(query_result)
        %{edges: [%{end: "person-9", group: "edges", start: "person-1",
           strength: 2, type: "INFLUENCED"},
         %{end: "person-6", group: "edges", start: "person-1",
           strength: 2, type: "INFLUENCED"},
         %{end: "person-3", group: "edges", start: "person-1",
           strength: 3, type: "INFLUENCED"}],
        nodes: [%{firstName: "Marcel", group: "nodes", labels: ["Person"],
           lastName: "MAUSS", name: "Marcel MAUSS", uuid: "person-9"},
         %{externalLink: "https://en.wikipedia.org/wiki/David_Hume",
           firstName: "David", group: "nodes",
           internalLink: "http://arsmagica.fr/polyphonies/hume-david-1711-1776",
           labels: ["Person"], lastName: "HUME", name: "David HUME",
           uuid: "person-1"},
         %{firstName: "Edmund", group: "nodes", labels: ["Person"],
           lastName: "HUSSERL", name: "Edmund HUSSERL", uuid: "person-6"},
         %{firstName: "Immanuel", group: "nodes", labels: ["Person"],
           lastName: "KANT", name: "Immanuel KANT", uuid: "person-3"}]}

  """
  def format(data) do
    flatten =
      data
      |> Enum.flat_map(fn val -> Enum.into(val, [], fn {_, v} -> v end) end)
      |> Enum.uniq_by(fn x -> x.id end)

    {nodes, relationships} =
      flatten
      |> Enum.split_with(fn x -> Map.has_key? x, :labels end)

    %{
      nodes: nodes
              |> Enum.map(&format_element/1),
      edges: relationships
              |> Enum.map(fn x -> update_relationships(x, flatten) end)
              |> Enum.map(&format_element/1)
    }
  end

  @doc """
  Converts Neo4j internal ids (for start and end node id) into their uuid
  counterparts.

  Uuids will be search into `data`, the complete query result, which needs to
  be flatten first.
  """
  def update_relationships(%Relationship{start: start_id, end: end_id} = element, data) do
    %{properties: %{"uuid" => start_uid}} =
      Enum.find(data, fn x -> x.id == start_id end)

    %{properties: %{"uuid" => end_uid}} =
      Enum.find(data, fn x -> x.id == end_id end)

    Map.merge(element, %{start: start_uid, end: end_uid})
  end

  def update_relationships(element, _) do
    element
  end

  @doc """
  Take a Bolt.Sips.Types result (Node or Relationship) and convert it to
  cytoscape format

  #### Example

      iex> data = %Bolt.Sips.Types.Relationship{end: "person-3", id: 1428,
      properties: %{"strength" => 3}, start: "person-1", type: "INFLUENCED"}

      iex> VinculiGraph.Format.Cytoscape.format_element(data)
      %{end: "person-3", group: "edges", start: "person-1", strength: 3,
        type: "INFLUENCED"}

      iex> data = %Bolt.Sips.Types.Node{id: 2381, labels: ["Person"],
      properties: %{"firstName" => "Immanuel", "lastName" => "KANT",
        "uuid" => "person-3"}}

      iex> VinculiGraph.Format.Cytoscape.format_element(data)
      %{firstName: "Immanuel", group: "nodes", labels: ["Person"], lastName: "KANT",
        name: "Immanuel KANT", uuid: "person-3"}
  """
  def format_element(%Node{labels: labels, properties: properties} = node_data) do
    data =
      Map.merge(properties, %{labels: labels})
      |> Map.put(:name, VinculiGraph.Helpers.get_name(node_data))
      |> Map.put(:id, properties["uuid"])
      |> Utils.Struct.to_atom_map()
      |> Map.drop([:uuid])

    %{data: data}
  end

  def format_element(%Relationship{start: start_uid, end: end_uid, type: type, properties: properties}) do
    data =
      Map.merge(properties, %{source: start_uid, target: end_uid, type: type})
      |> Utils.Struct.to_atom_map()

    %{data: data}
  end
end