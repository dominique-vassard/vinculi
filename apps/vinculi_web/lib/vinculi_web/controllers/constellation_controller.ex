defmodule VinculiWeb.ConstellationController do
  use VinculiWeb, :controller
  use Drab.Controller

  alias VinculiGraph.Meta
  # alias VinculiGraph.Node

  def index(conn, _params) do
    labels = Meta.list_labels()

    render conn, "index.html", labels: labels, fields: [], results: []
  end

  def explore(conn, params) do
    IO.puts inspect params
    render conn, "explore.html"
  end

  # def search(conn, %{"search" => node_form_params}) do
  #   IO.puts inspect node_form_params
  #   res = Node.get_fuzzy_by(Utils.Struct.to_atom_map node_form_params)
  #   IO.puts inspect res, pretty: true
  #   names = res
  #   |> Enum.into(%{}, fn(node) -> {VinculiGraph.Helpers.get_name(node), node.properties} end)
  #   IO.puts inspect names
  #   text conn, "yeap"
  # end
end
