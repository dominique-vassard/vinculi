defmodule VinculiGraph.Helpers do

  @doc """
    Retrieve non-id fields defined for schema.
    Non-id fields are tohse defined as primary key.

    Schemaa  must exists!

    ## Example:
    iex> get_non_id_fields "Person"
    [:first_name, :last_name, :aka, :internal_link, :external_link]
  """
  def get_non_id_fields(schema) do
    module = Module.concat(["VinculiGraph", schema])

    fields = Kernel.apply(module, :__schema__, [:fields])
    id_fields = Kernel.apply(module, :__schema__, [:primary_key])
    fields -- id_fields
  end
end