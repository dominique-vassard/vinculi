defmodule VinculiGraph.DatabaseHelpers do
@moduledoc """
Helpers for database tests
"""

  alias VinculiGraph.Repo
  alias VinculiGraph.TestPerson

  def insert_test_person(attrs = %{}) do
    changes = Map.merge(%{
      firstName: "Test_firstName",
      lastName: "Test_lastname",
      uuid: Ecto.UUID.generate()
    }, attrs)

    %TestPerson{}
      |> TestPerson.changeset(changes)
      |> Repo.insert!()

    changes
  end
end