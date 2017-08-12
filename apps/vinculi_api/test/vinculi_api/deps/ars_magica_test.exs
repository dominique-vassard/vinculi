defmodule VinculiApi.Deps.ArsMagicaTest do

  use VinculiApi.ConnCase

  test "Get taxonomy by id" do
    res = ArsMagica.Taxonomy.get(115)
    assert %Mariaex.Result{rows: [[115, "Balibar Françoise"]]} = res
    assert %Mariaex.Result{columns: ["tid", "name"]} = res
  end
end