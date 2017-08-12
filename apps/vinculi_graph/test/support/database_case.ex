defmodule VinculiGraph.DatabaseCase do
  @moduledoc """
  This module defines the test case to be used by
  database (repo) tests.

  You may define functions here to be used as helpers in
  your model tests. See `errors_on/2`'s definition as reference.

  Finally, as the test case interacts with the database,
  it cannot be async. Therefore, async is not allowed.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias VinculiGraph.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import VinculiGraph.DatabaseHelpers
      import VinculiGraph.TestPerson
      import VinculiGraph.DatabaseCase
    end
  end
end