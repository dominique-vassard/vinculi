defmodule VinculiApi.Deps.VinculiGraphTest do

  use VinculiApi.ConnCase
  alias VinculiGraph.TestPerson
  alias VinculiGraph.Repo

  test "[get!] single node based on uuid" do
    Repo.get!(TestPerson, "TestPerson-1")
  end
end