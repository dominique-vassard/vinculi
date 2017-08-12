defmodule ArsMagica.SupportCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias ArsMagica.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import ArsMagica.SupportCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(ArsMagica.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(ArsMagica.Repo, {:shared, self()})
    end

    :ok
  end
end