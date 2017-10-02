defmodule VinculiGraph.Helpers do
  def get_non_id_fields(schema) do
    module = Module.concat(["VinculiGraph", schema])

    fields = Kernel.apply(module, :__schema__, [:fields])
    id_fields = Kernel.apply(module, :__schema__, [:primary_key])
    fields -- id_fields
  end
end