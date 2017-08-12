defmodule ArsMagica.TaxonomyTest do
  use ExUnit.Case

  test "Query on arsmagbdd" do
    res = ArsMagica.Taxonomy.get(115)
    assert %{rows: [[115, "Balibar Françoise"]]} = res
    assert %{columns: ["tid", "name"]} = res
  end
end