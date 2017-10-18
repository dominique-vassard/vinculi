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
        "lastName" => "HUME", "uuid" => "person-1"}}}

    iex> VinculiGraph.Format.Cytoscape.format(data)
    [%{:labels => ["Person"], :name => "Marcel MAUSS", "firstName" => "Marcel",
       "lastName" => "MAUSS", "uuid" => "person-9"},
      %{:end => "person-9", :start => "person-1", :type => "INFLUENCED",
       "strength" => 2},
      %{:labels => ["Person"], :name => "David HUME",
       "externalLink" => "https://en.wikipedia.org/wiki/David_Hume",
       "firstName" => "David",
       "internalLink" => "http://arsmagica.fr/polyphonies/hume-david-1711-1776",
       "lastName" => "HUME", "uuid" => "person-1"},
      %{:labels => ["Person"], :name => "Edmund HUSSERL", "firstName" => "Edmund",
       "lastName" => "HUSSERL", "uuid" => "person-6"},
      %{:end => "person-6", :start => "person-1", :type => "INFLUENCED",
       "strength" => 2}]
  """
  def format(data) do
    flatten =
      data
      |> Enum.flat_map(fn val -> Enum.into(val, [], fn {_, v} -> v end) end)
      |> Enum.uniq_by(fn x -> x.id end)

    flatten
    |> (Enum.map(fn x -> update_relationships(x, flatten) end))
    |> Enum.map(&format_element/1)
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
      %{:end => "person-3", :start => "person-1", :type => "INFLUENCED", "strength" => 3}

      iex> data = %Bolt.Sips.Types.Node{id: 2381, labels: ["Person"],
      properties: %{"firstName" => "Immanuel", "lastName" => "KANT",
        "uuid" => "person-3"}}

      iex> VinculiGraph.Format.Cytoscape.format_element(data)
      %{:labels => ["Person"], :name => "Immanuel KANT",
                 "firstName" => "Immanuel", "lastName" => "KANT", "uuid" => "person-3"}
  """
  def format_element(%Node{labels: labels, properties: properties} = node_data) do
    Map.merge(properties, %{labels: labels})
    |> Map.put(:name, VinculiGraph.Helpers.get_name(node_data))
  end

  def format_element(%Relationship{start: start_uid, end: end_uid, type: type, properties: properties}) do
    Map.merge(properties, %{start: start_uid, end: end_uid, type: type})
  end
end