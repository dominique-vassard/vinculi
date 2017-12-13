defmodule VinculiGraph.Meta.Node do
  @moduledoc """
  Contains functions related to query constrtction for node
  """

  @doc """
  Returns cypher query to retrieve all node labels

  ### Example

      iex> VinculiGraph.Meta.Node.get_labels_cql()
      "CALL db.labels()"
  """
  def get_labels_cql() do
    "CALL db.labels()"
  end

  @doc """
  Returns Cypher query to get one node given its uuid

  ### Parameters

    - node_label: The node label to search on

  ### Example

      iex> VinculiGraph.Meta.Node.get_cql_get_by_uuid("Post")
      "MATCH\\n  (n:Post)\\nWHERE\\n  n.uuid = {uuid}\\nRETURN\\n  n\\n"
  """
  def get_cql_get_by_uuid(node_label) do
    """
    MATCH
      (n:#{node_label})
    WHERE
      n.uuid = {uuid}
    RETURN
      n
    """
  end

  @doc """
  Returns cypher qury and params to get a node local graph, i.e te given node
  and all its neighbours.

  #### Example

      iex> VinculiGraph.Meta.Node.get_cql_local_graph_by_uuid("Person", "unique_uid")
      {"MATCH\\n  (source:Person)-[relation]-(neighbour)\\nWHERE\\n  source.uuid = {nodeUuid}\\nRETURN\\n  source, relation, neighbour\\n",
      %{nodeUuid: "unique_uid"}}
  """
  def get_cql_local_graph_by_uuid(node_label, node_uuid) do
    cql = """
    MATCH
      (source:#{node_label})-[relation]-(neighbour)
    WHERE
      source.uuid = {nodeUuid}
    RETURN
      source, relation, neighbour
    """
    params = %{nodeUuid: node_uuid}
    {cql, params}
  end

  @doc """
  Returns cypher query to insert a node with the given properties, along with
  the parameters to use.

  Note: `uuid` is mandatory as it will be used to get/create the node

  ### Example:
      iex> data = %{uuid: "unique_id", title: "My post title"}
      %{title: "My post title", uuid: "unique_id"}
      iex> VinculiGraph.Meta.Node.get_cql_insert("Post", data)
      {"MERGE\\n  (n:Post {uuid: {uuid}})\\nSET\\nn.title = {title}RETURN\\n  n\\n",
      %{title: "My post title", uuid: "unique_id"}}
  """
  def get_cql_insert(node_label, data) do
    params = data

    r = data
    |> Enum.filter(fn {k, _} -> k != :uuid end)
    |> Enum.map(fn {k, _} -> "n.#{k} = {#{k}}" end)
    |> Enum.join(", \n")

    cql = """
    MERGE
      (n:#{node_label} {uuid: {uuid}})
    SET
    """ <> r <> """
    RETURN
      n
    """
    {cql, params}
  end

  @doc """
    Returns cypher query and params required to perform a fuzzy search, for the
    given the search data.

    ## Example:
        iex> VinculiGraph.Meta.Node.get_cql_fuzzy_by "Person", %{"firstName": "David", "lastName": ""}
        {"MATCH\\n  (n:Person)\\nWHERE\\n  toLower(n.firstName) CONTAINS {firstName}\\nRETURN n\\n",
        %{firstName: "david"}}
  """
  def get_cql_fuzzy_by(node_label, search_data) do
    #Use only non empty data
    node_data =
      search_data
      |> Enum.reject(fn {_field, value} -> is_empty?(value) end)

    cql = """
    MATCH
      (n:#{node_label})
    WHERE
      #{get_fuzzy_by_where(node_label, node_data)}
    RETURN n
    """
    params = get_fuzzy_by_params(node_data)
    {cql, params}
  end

  defp get_fuzzy_by_where(node_label, node_data) do
    fields_types = VinculiGraph.Helpers.get_fields_types(node_label)

    node_data
      |> Enum.map(fn {field, _} ->
          case fields_types[field] do
            :integer ->
              "toString(n.#{field} CONTAINS {#{field}}"
            :string ->
              "toLower(n.#{field}) CONTAINS {#{field}}"
          end
        end)
    |> Enum.join(" OR ")
  end

  defp get_fuzzy_by_params(node_data) do
    node_data
    |> Enum.into(%{}, fn {field, value} when is_binary value ->
                        {field, String.downcase(value)}
                      end)
  end

  defp is_empty?(value) when is_binary(value), do: String.length(value) == 0
  defp is_empty?(value) when is_list(value), do: length(value) == 0
  defp is_empty?(_), do: false
end