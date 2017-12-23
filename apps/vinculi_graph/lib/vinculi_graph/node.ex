defmodule VinculiGraph.Node do
  @moduledoc """
  Functions for graph operations on Node.
  """
  alias VinculiGraph.Repo
  alias VinculiGraph.Meta.Node
  alias VinculiGraph.Format.Cytoscape

  @doc """
  Return all labels used in database.

  ### Example

      iex> VinculiGraph.Node.get_labels()
      ["Town", "Country", "Continent", "Language", "Degree", "Year", "Institution",
       "Profession", "Domain", "School", "Person", "Publication", "Translation"]
  """
  def get_labels() do
    Repo.all(Node.get_labels_cql())
    |> Enum.map(fn %{"label" => label} -> label end)
  end

  @doc """
  Performs a fuzzy search on the given parameters.
  Given label must exists in VinculiGraph.Schema.

  #### Example

      iex> search = %{label: "Person", properties: %{firstName: "da"}}

      iex> VinculiGraph.Node.get_fuzzy_by(search)
      [%Bolt.Sips.Types.Node{id: 86, labels: ["Person"],
        properties: %{"externalLink" => "https://en.wikipedia.org/wiki/David_Hume",
          "firstName" => "David",
          "internalLink" => "http://arsmagica.fr/polyphonies/hume-david-1711-1776",
          "lastName" => "HUME", "uuid" => "person-1"}},
       %Bolt.Sips.Types.Node{id: 91, labels: ["Person"],
        properties: %{"firstName" => "Adam", "lastName" => "SMITH",
          "uuid" => "person-2"}}]

  """
  def get_fuzzy_by(%{label: label, properties: properties}) do
    schema = Module.concat(["VinculiGraph", label])
    struct = Kernel.apply(schema, :__struct__, [])
    changeset = schema.changeset(struct, properties)

    cond do
      Enum.count(changeset.changes) > 0 ->
        %{changes: search_data} = changeset
        Repo.get_fuzzy_by(schema, search_data)
        |> Enum.map(fn %{"n" => result} -> result end)
      true ->
        []
    end
  end

  @doc """
  Retrieve the local graph for the node with the given `label`and `uuid`.
  The local graph is the node and all its neighbours at a 1-relationship
  distance

  The optional parameter `format` allow to provide a formated result.

  Format available:
    - :cytoscape -> format to cytoscape-compliant map

  #### Example

      iex> VinculiGraph.Node.get_local_graph("Publication", "publication-22")
      [%{"neighbour" => %Bolt.Sips.Types.Node{id: 54, labels: ["Year"],
        properties: %{"uuid" => "year-29", "value" => 1902}},
       "relation" => %Bolt.Sips.Types.Relationship{end: 54, id: 202,
        properties: %{}, start: 130, type: "WHEN_WRITTEN"},
       "source" => %Bolt.Sips.Types.Node{id: 130, labels: ["Publication"],
        properties: %{"title" => "Esquisse d'une théorie générale de la magie",
          "uuid" => "publication-22"}}},
     %{"neighbour" => %Bolt.Sips.Types.Node{id: 24, labels: ["Language"],
        properties: %{"name" => "French", "uuid" => "language-3"}},
       "relation" => %Bolt.Sips.Types.Relationship{end: 24, id: 203,
        properties: %{}, start: 130, type: "HAS_ORIGINAL_LANGUAGE"},
       "source" => %Bolt.Sips.Types.Node{id: 130, labels: ["Publication"],
        properties: %{"title" => "Esquisse d'une théorie générale de la magie",
          "uuid" => "publication-22"}}},
     %{"neighbour" => %Bolt.Sips.Types.Node{id: 128, labels: ["Person"],
        properties: %{"firstName" => "Marcel", "lastName" => "MAUSS",
          "uuid" => "person-9"}},
       "relation" => %Bolt.Sips.Types.Relationship{end: 130, id: 201,
        properties: %{}, start: 128, type: "WROTE"},
       "source" => %Bolt.Sips.Types.Node{id: 130, labels: ["Publication"],
        properties: %{"title" => "Esquisse d'une théorie générale de la magie",
          "uuid" => "publication-22"}}},
     %{"neighbour" => %Bolt.Sips.Types.Node{id: 73, labels: ["Domain"],
        properties: %{"name" => "Anthropology", "uuid" => "domain-2"}},
       "relation" => %Bolt.Sips.Types.Relationship{end: 73, id: 204,
        properties: %{}, start: 130, type: "IS_OF_DOMAIN"},
       "source" => %Bolt.Sips.Types.Node{id: 130, labels: ["Publication"],
        properties: %{"title" => "Esquisse d'une théorie générale de la magie",
          "uuid" => "publication-22"}}}]

      iex> VinculiGraph.Node.get_local_graph("Publication", "publication-22")
      [%{:labels => ["Year"], :name => "1902", "uuid" => "year-29", "value" => 1902},
       %{end: "year-29", start: "publication-22", type: "WHEN_WRITTEN"},
       %{:labels => ["Publication"], :name => "",
         "title" => "Esquisse d'une théorie générale de la magie",
         "uuid" => "publication-22"},
       %{:labels => ["Language"], :name => "French", "name" => "French",
         "uuid" => "language-3"},
       %{end: "language-3", start: "publication-22", type: "HAS_ORIGINAL_LANGUAGE"},
       %{:labels => ["Person"], :name => "Marcel MAUSS", "firstName" => "Marcel",
         "lastName" => "MAUSS", "uuid" => "person-9"},
       %{end: "publication-22", start: "person-9", type: "WROTE"},
       %{:labels => ["Domain"], :name => "Anthropology", "name" => "Anthropology",
         "uuid" => "domain-2"},
       %{end: "domain-2", start: "publication-22", type: "IS_OF_DOMAIN"}]
  """
  def get_local_graph(label, uuid, format \\ nil)
  def get_local_graph(label, uuid, :cytoscape) do
    do_get_local_graph(label, uuid)
    |> Cytoscape.format()
  end

  def get_local_graph(label, uuid, _) do
    do_get_local_graph(label, uuid)
  end

  defp do_get_local_graph(label, uuid) do
    {cql, params} = Node.get_cql_local_graph_by_uuid(label, uuid)
    Repo.all cql, params
  end
end