defmodule VinculiGraph.Meta do
  @moduledoc """
    Metadata of the graph
  """
  alias VinculiGraph.Repo

  alias VinculiGraph.Meta.Graph

  def list_labels() do
    Repo.all(Graph.get_schema_cql())
    |> Graph.extract_node_labels()
  end

  @doc """
  Get nodes that match the geiven label and properties.
  Empty property will not be used.
  It's a fuzzy search, not an exact one, then:
  `get_fuzzy_node_by %{label: "Domain",properties: %{"name", "the"}}`
  will produce:
  `MATCH (n:Domain) WHERE toLower(n.name) CONTAINS 'the'`

  With same logic, integers will be compared as string, then:
  `get_fuzzy_node_by %{label: "Year",properties: %{"value", "17"}}`
  will produce:
  `MATCH (n:Year) WHERE toString(n.value) CONTAINS '17'`
  """
  def get_fuzzy_node_by(%{label: label, properties: properties}) do
    schema = Module.concat(["VinculiGraph", label])
    struct = Kernel.apply(schema, :__struct__, [])
    %{changes: search_data} = schema.changeset(struct, properties)

    node_data =
      search_data
      |> Enum.reject(fn {_field, value} -> is_empty?(value) end)

    cql = "MATCH (n:#{label}) WHERE " <> get_where(schema, node_data) <> " RETURN n"

    res = VinculiGraph.Repo.all cql, get_params(node_data)
    res |> Enum.map(fn %{"n" => result} -> result end)
  end

  defp get_where(schema, node_data) do
    node_data
      |> Enum.map(fn {field, _} ->
      case Kernel.apply(schema, :__schema__, [:type, field]) do
        :integer ->
          "toString(n.#{Utils.String.camelize field} CONTAINS {#{field}}"
        :string ->
          "toLower(n.#{Utils.String.camelize field}) CONTAINS {#{field}}"
      end
    end)
    |> Enum.join(" AND ")
  end

  defp get_params(node_data) do
    node_data
    |> Enum.into(%{}, fn {field, value} when is_binary value ->
                        {field, String.downcase(value)}
                      end)
  end

  defp is_empty?(value) when is_binary(value), do: String.length(value) == 0
  defp is_empty?(value) when is_list(value), do: length(value) == 0
  defp is_empty?(value), do: false
end