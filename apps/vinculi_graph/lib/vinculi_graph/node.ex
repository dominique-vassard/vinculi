defmodule VinculiGraph.Node do
  alias VinculiGraph.Repo

  def get_fuzzy_by(%{label: label, properties: properties}) do
    schema = Module.concat(["VinculiGraph", label])
    struct = Kernel.apply(schema, :__struct__, [])
    %{changes: search_data} = schema.changeset(struct, properties)

    Repo.get_fuzzy_by(schema, search_data)
  end
end