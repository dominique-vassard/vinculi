defmodule VinculiWeb.ConstellationController do
  use VinculiWeb, :controller
  use Drab.Controller

  alias VinculiGraph.Meta
  # alias VinculiGraph.Node

  def index(conn, _params) do
    labels = Meta.list_labels()

    render conn, "index.html", labels: labels, fields: [], results: []
  end

  def explore(conn, %{"labels" => node_labels, "node_uuid" => node_uuid}) do
    # node_uuid = "person-2"
    # IO.puts inspect params
    server_url = endpoint_module(conn).url()

    socket_prefix = get_socket_prefix(Application.get_env(:vinculi_web, :env))
    socket_host = get_socket_host(conn, Application.get_env(:vinculi_web, :env))
    socket_url = socket_prefix <> "://#{socket_host}" <> "/socket/websocket"

    render conn, "explore.html", layout: {VinculiWeb.LayoutView, "app_light.html"},
                                 node_uuid: node_uuid,
                                 node_labels: node_labels,
                                 server_url: server_url,
                                 socket_url: socket_url
  end

  def get_socket_prefix(:prod), do: "wss"
  def get_socket_prefix(_), do: "ws"
  def get_socket_host(conn, :prod), do: conn.host
  def get_socket_host(conn, _), do: "#{conn.host}:#{conn.port}"

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
