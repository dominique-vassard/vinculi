defmodule VinculiApi.Deps.VinculiGraphTest do

  use VinculiApi.ConnCase
  alias VinculiGraph.TestPerson
  alias VinculiGraph.Repo

  @valid_changes %{
    firstName: "Test_firstName",
    lastName: "Test_lastname",
    uuid: Ecto.UUID.generate()
  }

  test "[get!] single node based on uuid" do
    changes = Map.put(@valid_changes, :uuid, "TestPerson-1")
    {res, _} = %TestPerson{}
      |> TestPerson.changeset(changes)
      |> Repo.insert()
      assert res == :ok

    Repo.get!(TestPerson, "TestPerson-1")
  end
end