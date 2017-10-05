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

  def get_fuzzy_node_by(%{"label" => label, "properties" => properties}) do
    schema = Module.concat(["VinculiGraph", label])
    struct = Kernel.apply(schema, :__struct__, [])
    %{changes: search_data} = Ecto.Changeset.change(struct, properties)

    filtered_node =
      search_data
      |> Enum.reject(fn {_field, value} -> String.length(value) == 0 end)

    where =
      filtered_node
      |> Enum.map(fn {field, _} ->
      case Kernel.apply(schema, :__schema__, [:type, String.to_atom field]) do
        :integer -> "toString(n.#{to_camel field} CONTAINS {#{field}}"
        :string -> "toLower(n.#{to_camel field}) CONTAINS {#{field}}"
      end
    end)
    |> Enum.join(" AND ")

    params =
      filtered_node
      |> Enum.into(%{}, fn {field, value} -> {String.to_atom(field), String.downcase(value)} end)

    cql = "MATCH (n:#{label}) WHERE " <> where <> " RETURN n"


    r = VinculiGraph.Repo.all cql, params
    IO.puts inspect r
    # Enum.each(search_data, fn x -> IO.puts(inspect x) end)

    # Kernel.apply(schema, :__schema__, [])
  end

  def to_camel(value) do
     value
    |> String.trim
    |> replace(~r/^[_\.\-\s]+/, "")
    |> replace(~r/([a-zA-Z]+)([A-Z][a-z\d]+)/, "\\1-\\2")
    |> String.downcase
    |> replace(~r/[_\.\-\s]+(\w|$)/, fn(_, x) -> String.upcase(x) end)
  end

  def replace(value, regex, new_value) do
    Regex.replace(regex, value, new_value)
  end
end