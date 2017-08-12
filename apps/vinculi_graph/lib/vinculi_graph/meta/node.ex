defmodule VinculiGraph.Meta.Node do
  @moduledoc """
  Contains functions related to node at a general level
  """

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
end