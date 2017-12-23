defmodule VinculiGraph.TestNode do
  use VinculiGraph.DatabaseCase

  alias VinculiGraph.Node

  def check_query_result(expected, result) do
    flat_res =
      result
        |> Enum.flat_map(fn val -> Enum.into(val, [], fn {_, v} -> v end) end)
        |> Enum.uniq_by(fn x -> x.id end)

    flat_expected =
    expected
      |> Enum.flat_map(fn val -> Enum.into(val, [], fn {_, v} -> v end) end)
      |> Enum.uniq_by(fn x -> x.id end)

    check_result(flat_expected, flat_res)
  end

  def check_result(expected, result) do
    filtered =
        result
        |> Enum.filter(fn x -> Enum.find(expected, fn y -> x.properties["uuid"] == y.properties["uuid"] end) end)

    assert Enum.count(filtered) == Enum.count(expected)
  end

  test "Test get_labels/0" do
    expected = [
      "Town", "Country", "Continent", "Language", "Degree", "Year",
      "Institution", "Profession", "Domain", "School", "Person", "Publication",
      "Translation"]
    assert Node.get_labels() == expected
  end

  describe "Test get_fuzzy_by/1:" do
    test "Return valid result with valid params" do
      search = %{label: "Person", properties: %{firstName: "da"}}
      res = Node.get_fuzzy_by(search)
      expected = [%Bolt.Sips.Types.Node{id: 86, labels: ["Person"],
        properties: %{"externalLink" => "https://en.wikipedia.org/wiki/David_Hume",
          "firstName" => "David",
          "internalLink" => "http://arsmagica.fr/polyphonies/hume-david-1711-1776",
          "lastName" => "HUME", "uuid" => "person-1"}},
       %Bolt.Sips.Types.Node{id: 91, labels: ["Person"],
        properties: %{"firstName" => "Adam", "lastName" => "SMITH",
          "uuid" => "person-2"}}]

      check_result(expected, res)
    end

    test "Return empty result when no results found" do
      search = %{label: "Person", properties: %{firstName: "non-existing"}}
      assert [] == Node.get_fuzzy_by(search)
    end
  end

  describe "Test get_local_graph/2:" do
    test "Return non-formated result" do
      res = Node.get_local_graph("Publication", "publication-22")
      expected = [%{"neighbour" => %Bolt.Sips.Types.Node{id: 54, labels: ["Year"],
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

      check_query_result(expected, res)
    end

    test "Return cytoscape-formated result when asked to" do
      res = Node.get_local_graph("Publication", "publication-22", :cytoscape)
      expected = [%{data: %{id: "domain-2", labels: ["Domain"], name: "Anthropology"},
           group: "nodes"},
         %{data: %{id: "publication-22", labels: ["Publication"],
             name: "Esquisse d'une théorie générale de la magie",
             title: "Esquisse d'une théorie générale de la magie",
             titleFr: "Esquisse d'une théorie générale de la magie"},
           group: "nodes"},
         %{data: %{id: "year-29", labels: ["Year"], name: "1902", value: 1902},
           group: "nodes"},
         %{data: %{id: "language-3", labels: ["Language"], name: "French"},
           group: "nodes"},
         %{data: %{firstName: "Marcel", id: "person-9", labels: ["Person"],
             lastName: "MAUSS", name: "Marcel MAUSS"}, group: "nodes"},
         %{data: %{id: "publication-22+domain-2", source: "publication-22",
             target: "domain-2", type: "IS_OF_DOMAIN"}, group: "edges"},
         %{data: %{id: "publication-22+year-29", source: "publication-22",
             target: "year-29", type: "WHEN_WRITTEN"}, group: "edges"},
         %{data: %{id: "publication-22+language-3", source: "publication-22",
             target: "language-3", type: "HAS_ORIGINAL_LANGUAGE"}, group: "edges"},
         %{data: %{id: "person-9+publication-22", source: "person-9",
             target: "publication-22", type: "WROTE"}, group: "edges"}]

      assert Enum.sort(expected) == Enum.sort(res)
    end

    test "Return empty result for non-existing node" do
      assert [] == Node.get_local_graph("Person", "non-existing")
    end

  end
end