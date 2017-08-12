defmodule BasicConnectionTest do
  use ExUnit.Case

  test "Test database connection" do
    query = "SELECT tid, name FROM taxonomy_term_data WHERE tid = 115"
    assert {:ok, res} = Ecto.Adapters.SQL.query(ArsMagica.Repo, query)

    assert %Mariaex.Result{rows: [[115, "Balibar Françoise"]]} = res
  end
end
