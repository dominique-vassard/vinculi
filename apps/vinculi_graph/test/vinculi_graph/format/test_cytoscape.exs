defmodule VinculiGraph.Format.TestCytoscape do
  use ExUnit.Case

  alias VinculiGraph.Format.Cytoscape

  @query_result [%{"neighbour" => %Bolt.Sips.Types.Node{id: 2415, labels: ["Person"],
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
          "lastName" => "HUME", "uuid" => "person-1"}}},
      %{"neighbour" => %Bolt.Sips.Types.Node{id: 2381, labels: ["Person"],
        properties: %{"firstName" => "Immanuel", "lastName" => "KANT",
          "uuid" => "person-3"}},
       "relation" => %Bolt.Sips.Types.Relationship{end: 2381, id: 1428,
        properties: %{"strength" => 3}, start: 2373, type: "INFLUENCED"},
       "source" => %Bolt.Sips.Types.Node{id: 2373, labels: ["Person"],
        properties: %{"externalLink" => "https://en.wikipedia.org/wiki/David_Hume",
          "firstName" => "David",
          "internalLink" => "http://arsmagica.fr/polyphonies/hume-david-1711-1776",
          "lastName" => "HUME", "uuid" => "person-1"}}}]

  @flat_query_result [%Bolt.Sips.Types.Node{id: 2415, labels: ["Person"],
      properties: %{"firstName" => "Marcel", "lastName" => "MAUSS",
        "uuid" => "person-9"}},
     %Bolt.Sips.Types.Relationship{end: 2415, id: 1432,
      properties: %{"strength" => 2}, start: 2373, type: "INFLUENCED"},
     %Bolt.Sips.Types.Node{id: 2373, labels: ["Person"],
      properties: %{"externalLink" => "https://en.wikipedia.org/wiki/David_Hume",
        "firstName" => "David",
        "internalLink" => "http://arsmagica.fr/polyphonies/hume-david-1711-1776",
        "lastName" => "HUME", "uuid" => "person-1"}},
     %Bolt.Sips.Types.Node{id: 2398, labels: ["Person"],
      properties: %{"firstName" => "Edmund", "lastName" => "HUSSERL",
        "uuid" => "person-6"}},
     %Bolt.Sips.Types.Relationship{end: 2398, id: 1429,
      properties: %{"strength" => 2}, start: 2373, type: "INFLUENCED"},
     %Bolt.Sips.Types.Node{id: 2381, labels: ["Person"],
      properties: %{"firstName" => "Immanuel", "lastName" => "KANT",
        "uuid" => "person-3"}},
     %Bolt.Sips.Types.Relationship{end: 2381, id: 1428,
      properties: %{"strength" => 3}, start: 2373, type: "INFLUENCED"}]

  describe "Test format/1:" do
    test "produces a valid json for cytoscape" do
      expected = %{edges: [%{data: %{target: "person-9", source: "person-1", strength: 2,
           type: "INFLUENCED"}},
       %{data: %{target: "person-6", source: "person-1", strength: 2,
           type: "INFLUENCED"}},
       %{data: %{target: "person-3", source: "person-1", strength: 3,
           type: "INFLUENCED"}}],
      nodes: [%{data: %{firstName: "Marcel", labels: ["Person"], lastName: "MAUSS",
           name: "Marcel MAUSS", id: "person-9"}},
       %{data: %{externalLink: "https://en.wikipedia.org/wiki/David_Hume",
           firstName: "David",
           internalLink: "http://arsmagica.fr/polyphonies/hume-david-1711-1776",
           labels: ["Person"], lastName: "HUME", name: "David HUME",
           id: "person-1"}},
       %{data: %{firstName: "Edmund", labels: ["Person"], lastName: "HUSSERL",
           name: "Edmund HUSSERL", id: "person-6"}},
       %{data: %{firstName: "Immanuel", labels: ["Person"], lastName: "KANT",
           name: "Immanuel KANT", id: "person-3"}}]}

      res = Cytoscape.format(@query_result)

      assert expected == res
    end

    test "produces valid json for cytoscape with confusing node/rel ids" do
      query_result = [%{"neighbour" => %Bolt.Sips.Types.Node{id: 13, labels: ["Country"],
        properties: %{"name" => "Scotland", "uuid" => "country-1"}},
       "relation" => %Bolt.Sips.Types.Relationship{end: 13, id: 1, properties: %{},
        start: 1, type: "IS_IN_COUNTRY"},
       "source" => %Bolt.Sips.Types.Node{id: 1, labels: ["Town"],
        properties: %{"name" => "Kirkcaldy", "uuid" => "town-2"}}}]

      expected = %{edges: [%{data: %{source: "town-2", target: "country-1",
           type: "IS_IN_COUNTRY"}}],
      nodes: [%{data: %{id: "country-1", labels: ["Country"], name: "Scotland"}},
       %{data: %{id: "town-2", labels: ["Town"], name: "Kirkcaldy"}}]}

      assert expected == Cytoscape.format(query_result)
    end
  end

  describe "Test update_relationships/2:" do
    test "on Bolt.Sips.Types.Relationship should work well" do
      data = %Bolt.Sips.Types.Relationship{end: 2381, id: 1428,
        properties: %{"strength" => 3}, start: 2373, type: "INFLUENCED"}

      expected = %Bolt.Sips.Types.Relationship{end: "person-3", id: 1428,
        properties: %{"strength" => 3}, start: "person-1", type: "INFLUENCED"}

      assert expected == Cytoscape.update_relationships(data,
                                                         @flat_query_result)

    end

    test "on Bolt.Sips.Types.Node should not do anything" do
      data =  %Bolt.Sips.Types.Node{id: 2381, labels: ["Person"],
      properties: %{"firstName" => "Immanuel", "lastName" => "KANT",
        "uuid" => "person-3"}}

      assert data == Cytoscape.update_relationships(data, @flat_query_result)
    end

    test "on other map should not do anything" do
      assert %{} == Cytoscape.update_relationships(%{}, @flat_query_result)
    end
  end

  describe "Test format_element/1" do
    test "Bolt.Sips.Types.Relationship should produce valid cytoscape data" do
      data = %Bolt.Sips.Types.Relationship{end: "person-3", id: 1428,
        properties: %{"strength" => 3}, start: "person-1", type: "INFLUENCED"}

      expected = %{data: %{target: "person-3", source: "person-1", strength: 3,
                   type: "INFLUENCED"}}
      assert expected == Cytoscape.format_element(data)
    end

    test "Bolt.Sips.Types.Node should produce valid cytoscape data" do
      data = %Bolt.Sips.Types.Node{id: 2381, labels: ["Person"],
        properties: %{"firstName" => "Immanuel", "lastName" => "KANT",
          "uuid" => "person-3"}}

      expected = %{data: %{firstName: "Immanuel", labels: ["Person"],
                   lastName: "KANT", name: "Immanuel KANT", id: "person-3"}}
      assert expected == Cytoscape.format_element(data)
    end
  end
end