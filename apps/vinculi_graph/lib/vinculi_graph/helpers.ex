defmodule VinculiGraph.Helpers do
  @doc """
    Retrieve non-id fields defined for schema.
    Non-id fields are those defined as primary key.

    Schema must exists!

    ## Example:
    iex> VinculiGraph.Helpers.get_non_id_fields "Person"
    [:first_name, :last_name, :aka, :internal_link, :external_link]
  """
  def get_non_id_fields(schema) when is_binary schema do
    Module.concat(["VinculiGraph", schema])
    |> Kernel.apply(:get_non_id_fields, [])
  end

  @doc """
    Retrieve name for display

    Schema must exists!

    ## Example:
        iex> VinculiGraph.Helpers.get_name %{labels: ["Year"], properties: %{"value" => 1798}}
        "1798"
  """
  def get_name(%{labels: labels, properties: properties}) do
    prop_list = get_name_fields(List.first labels)
    |> Enum.map(&Utils.String.camelize/1)

    properties
    |> Enum.filter(fn {k, _} -> Enum.member?(prop_list, k) end)
    |> Enum.map(fn {_, v} -> v end)
    |> Enum.join(" ")
  end

  @doc """
    Retreives fields used for the node name.

    Schema must exists

    ## Example:
        iex> VinculiGraph.Helpers.get_name_fields("Person")
        [:first_name, :last_name]
  """
  def get_name_fields(schema) do
    Module.concat(["VinculiGraph", schema])
    |> Kernel.apply(:get_name_fields, [])
  end
end