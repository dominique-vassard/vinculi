defmodule VinculiGraph.Node do
  alias VinculiGraph.Repo

  def get_fuzzy_by(%{label: label, properties: properties}) do
    schema = Module.concat(["VinculiGraph", label])
    struct = Kernel.apply(schema, :__struct__, [])
    changeset = schema.changeset(struct, properties)

    cond do
      Enum.count(changeset.changes) > 0 ->
        %{changes: search_data} = changeset
        Repo.get_fuzzy_by(schema, search_data)
        |> Enum.map(fn %{"n" => result} -> result end)
      true ->
        []
    end
  end
end