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
      expected = [
        %{firstName: "Marcel", group: "nodes", labels: ["Person"], lastName: "MAUSS",
         name: "Marcel MAUSS", uuid: "person-9"},
        %{end: "person-9", group: "edges", start: "person-1", strength: 2,
         type: "INFLUENCED"},
        %{externalLink: "https://en.wikipedia.org/wiki/David_Hume", firstName: "David",
         group: "nodes",
         internalLink: "http://arsmagica.fr/polyphonies/hume-david-1711-1776",
         labels: ["Person"], lastName: "HUME", name: "David HUME", uuid: "person-1"},
        %{firstName: "Edmund", group: "nodes", labels: ["Person"], lastName: "HUSSERL",
         name: "Edmund HUSSERL", uuid: "person-6"},
        %{end: "person-6", group: "edges", start: "person-1", strength: 2,
         type: "INFLUENCED"},
        %{firstName: "Immanuel", group: "nodes", labels: ["Person"], lastName: "KANT",
         name: "Immanuel KANT", uuid: "person-3"},
        %{end: "person-3", group: "edges", start: "person-1", strength: 3,
         type: "INFLUENCED"}]

      res = Cytoscape.format(@query_result)
      assert expected == res
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

      expected = %{end: "person-3", group: "edges", start: "person-1",
                   strength: 3, type: "INFLUENCED"}
      assert expected == Cytoscape.format_element(data)
    end

    test "Bolt.Sips.Types.Node should produce valid cytoscape data" do
      data = %Bolt.Sips.Types.Node{id: 2381, labels: ["Person"],
        properties: %{"firstName" => "Immanuel", "lastName" => "KANT",
          "uuid" => "person-3"}}

      expected = %{firstName: "Immanuel", group: "nodes", labels: ["Person"],
                   lastName: "KANT", name: "Immanuel KANT", uuid: "person-3"}
      assert expected == Cytoscape.format_element(data)
    end
  end
end