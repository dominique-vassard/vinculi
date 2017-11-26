defmodule VinculiGraph.Format.TestCytoscape do
  use ExUnit.Case
  import AssertValue

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
     %Bolt.Sips.Types.Node{id: 2373, labels: ["Person"],
      properties: %{"externalLink" => "https://en.wikipedia.org/wiki/David_Hume",
        "firstName" => "David",
        "internalLink" => "http://arsmagica.fr/polyphonies/hume-david-1711-1776",
        "lastName" => "HUME", "uuid" => "person-1"}},
     %Bolt.Sips.Types.Node{id: 2398, labels: ["Person"],
      properties: %{"firstName" => "Edmund", "lastName" => "HUSSERL",
        "uuid" => "person-6"}},
     %Bolt.Sips.Types.Node{id: 2381, labels: ["Person"],
      properties: %{"firstName" => "Immanuel", "lastName" => "KANT",
        "uuid" => "person-3"}}]

  describe "Test format/1:" do
    test "produces a valid json for cytoscape" do
      res = inspect Cytoscape.format(@query_result), pretty: true
      assert_value res == """
      [%{data: %{firstName: \"Marcel\", id: \"person-9\", labels: [\"Person\"],
           lastName: \"MAUSS\", name: \"Marcel MAUSS\"}, group: \"nodes\"},
       %{data: %{externalLink: \"https://en.wikipedia.org/wiki/David_Hume\",
           firstName: \"David\", id: \"person-1\",
           internalLink: \"http://arsmagica.fr/polyphonies/hume-david-1711-1776\",
           labels: [\"Person\"], lastName: \"HUME\", name: \"David HUME\"}, group: \"nodes\"},
       %{data: %{firstName: \"Edmund\", id: \"person-6\", labels: [\"Person\"],
           lastName: \"HUSSERL\", name: \"Edmund HUSSERL\"}, group: \"nodes\"},
       %{data: %{firstName: \"Immanuel\", id: \"person-3\", labels: [\"Person\"],
           lastName: \"KANT\", name: \"Immanuel KANT\"}, group: \"nodes\"},
       %{data: %{id: \"person-1+person-9\", source: \"person-1\", strength: 2,
           target: \"person-9\", type: \"INFLUENCED\"}, group: \"edges\"},
       %{data: %{id: \"person-1+person-6\", source: \"person-1\", strength: 2,
           target: \"person-6\", type: \"INFLUENCED\"}, group: \"edges\"},
       %{data: %{id: \"person-1+person-3\", source: \"person-1\", strength: 3,
           target: \"person-3\", type: \"INFLUENCED\"}, group: \"edges\"}]<NOEOL>
      """
    end

    test "produces valid json for cytoscape with confusing node/rel ids" do
      query_result = [%{"neighbour" => %Bolt.Sips.Types.Node{id: 13, labels: ["Country"],
        properties: %{"name" => "Scotland", "uuid" => "country-1"}},
       "relation" => %Bolt.Sips.Types.Relationship{end: 13, id: 1, properties: %{},
        start: 1, type: "IS_IN_COUNTRY"},
       "source" => %Bolt.Sips.Types.Node{id: 1, labels: ["Town"],
        properties: %{"name" => "Kirkcaldy", "uuid" => "town-2"}}}]

      res = inspect Cytoscape.format(query_result), pretty: true
      assert_value res == """
      [%{data: %{id: \"country-1\", labels: [\"Country\"], name: \"Scotland\"},
         group: \"nodes\"},
       %{data: %{id: \"town-2\", labels: [\"Town\"], name: \"Kirkcaldy\"}, group: \"nodes\"},
       %{data: %{id: \"town-2+country-1\", source: \"town-2\", target: \"country-1\",
           type: \"IS_IN_COUNTRY\"}, group: \"edges\"}]<NOEOL>
      """
    end
  end

  describe "Test update_relationships/2:" do
    test "on Bolt.Sips.Types.Relationship should work well" do
      data = %Bolt.Sips.Types.Relationship{end: 2381, id: 1428,
        properties: %{"strength" => 3}, start: 2373, type: "INFLUENCED"}

      res = inspect Cytoscape.update_relationships(data, @flat_query_result), pretty: true
      assert_value res == """
      %Bolt.Sips.Types.Relationship{end: \"person-3\", id: 1428,
       properties: %{\"strength\" => 3}, start: \"person-1\", type: \"INFLUENCED\"}<NOEOL>
      """
    end

    test "on Bolt.Sips.Types.Node should not do anything" do
      data =  %Bolt.Sips.Types.Node{id: 2381, labels: ["Person"],
      properties: %{"firstName" => "Immanuel", "lastName" => "KANT",
        "uuid" => "person-3"}}

      res = inspect Cytoscape.update_relationships(data, @flat_query_result), pretty: true
      assert_value res == """
      %Bolt.Sips.Types.Node{id: 2381, labels: [\"Person\"],
       properties: %{\"firstName\" => \"Immanuel\", \"lastName\" => \"KANT\",
         \"uuid\" => \"person-3\"}}<NOEOL>
      """
    end

    test "on other map should not do anything" do
      assert %{} == Cytoscape.update_relationships(%{}, @flat_query_result)
    end
  end

  describe "Test format_element/1" do
    test "Bolt.Sips.Types.Relationship should produce valid cytoscape data" do
      data = %Bolt.Sips.Types.Relationship{end: "person-3", id: 1428,
        properties: %{"strength" => 3}, start: "person-1", type: "INFLUENCED"}

      res = inspect Cytoscape.format_element(data), pretty: true
      assert_value res == """
      %{data: %{id: \"person-1+person-3\", source: \"person-1\", strength: 3,
          target: \"person-3\", type: \"INFLUENCED\"}, group: \"edges\"}<NOEOL>
      """
    end

    test "Bolt.Sips.Types.Node should produce valid cytoscape data" do
      data = %Bolt.Sips.Types.Node{id: 2381, labels: ["Person"],
        properties: %{"firstName" => "Immanuel", "lastName" => "KANT",
          "uuid" => "person-3"}}

      res = inspect Cytoscape.format_element(data), pretty: true
      assert_value res == """
      %{data: %{firstName: \"Immanuel\", id: \"person-3\", labels: [\"Person\"],
          lastName: \"KANT\", name: \"Immanuel KANT\"}, group: \"nodes\"}<NOEOL>
      """
    end
  end
end