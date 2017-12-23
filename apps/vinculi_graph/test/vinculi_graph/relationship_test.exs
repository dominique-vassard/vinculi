defmodule VinculiGraph.RelationshipTest do
    use VinculiGraph.DatabaseCase

    alias VinculiGraph.Relationship

    test "Test get_types/0" do
        expected = [
            "IS_IN_COUNTRY", "IS_IN_CONTINENT", "WHERE_BORN", "WHEN_BORN",
            "WHERE_DIED", "WHEN_DIED", "WROTE", "WHEN_WRITTEN", "IS_OF_DOMAIN",
            "IS_OF_SCHOOL", "HAS_ORIGINAL_LANGUAGE", "HAS_DEGREE",
            "DEGREE_FROM", "HAS_PROFESSION", "EMPLOYED_BY", "EMPLOYED_FROM",
            "EMPLOYED_TO", "TRANSLATED", "TRANSLATED_IN_LANGUAGE",
            "WHEN_TRANSLATED", "CO_WROTE", "INFLUENCED"]
        assert Relationship.get_types() == expected
    end
end