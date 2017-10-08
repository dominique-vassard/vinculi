defmodule VinculiGraph.Helpers do
  @doc """
    Retrieve non-id fields defined for schema.
    Non-id fields are those defined as primary key.

    Schema must exists!

    ## Example:
    iex> VinculiGraph.Helpers.get_non_id_fields "Person"
    [:firstName, :lastName, :aka, :internalLink, :externalLink]
  """
  def get_non_id_fields(schema) when is_binary schema do
    Module.concat(["VinculiGraph", schema])
    |> get_non_id_fields()
  end

  def get_non_id_fields(schema) do
    schema.get_non_id_fields()
  end

  @doc """
    Retrieve name for display

    Schema must exists!

    ## Example:
        iex> VinculiGraph.Helpers.get_name %{labels: ["Person"], properties: %{firstName: "David", lastName: "HUME"}}
        "David HUME"
  """
  def get_name(%{labels: labels, properties: properties}) do
    prop_list = get_name_fields(List.first labels)

    properties
    |> Enum.filter(fn {k, _} -> Enum.member?(prop_list, k) end)
    |> Enum.map(fn {_, v} -> v end)
    |> Enum.join(" ")
  end

  @doc """
    Retreives fields used for the node name.

    Schema must exists!

    ## Example:
        iex> VinculiGraph.Helpers.get_name_fields("Person")
        [:firstName, :lastName]
  """
  def get_name_fields(schema) do
    Module.concat(["VinculiGraph", schema])
    |> Kernel.apply(:get_name_fields, [])
  end

  @doc """
    Retrieves fields types for the given schema.

    ## Example:
        iex> VinculiGraph.Helpers.get_fields_types("Person")
        %{aka: :string, externalLink: :string, firstName: :string,
             internalLink: :string, lastName: :string}
  """
  def get_fields_types(schema) when is_binary(schema) do
    Module.concat(["VinculiGraph", schema])
    |> get_fields_types()
  end

  @doc """
    Retrieves fields types for the given schema.

    ## Example:
        iex> VinculiGraph.Helpers.get_fields_types(VinculiGraph.Person)
        %{aka: :string, externalLink: :string, firstName: :string,
             internalLink: :string, lastName: :string}
  """
  def get_fields_types(schema) do
    get_non_id_fields(schema)
    |> Enum.into(%{}, fn field -> {field, schema.__schema__(:type, field)} end)
  end
end