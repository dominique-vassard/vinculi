defmodule VinculiWeb.ConstellationController do
  use VinculiWeb, :controller

  def index(conn, _params) do
    labels = VinculiGraph.Meta.list_labels()

    render conn, "index.html", labels: labels, fields: []
  end

  # def search(conn, %{"search" => %{"label" => label, "name" => name}}) do
    # IO.puts "Search for #{label} with name #{name}"
  def search(conn, %{"search" => %{"label" => label}}) do
    # IO.puts inspect search_params
    labels = VinculiGraph.Meta.list_labels()
    results = []
    render conn, "index.html", labels: labels, fields: get_non_id_fields(label)
  end

  def get_non_id_fields(node_type) do
    module = Module.concat(["VinculiGraph", node_type])

    fields = Kernel.apply(module, :__schema__, [:fields])
    id_fields = Kernel.apply(module, :__schema__, [:primary_key])
    fields -- id_fields
  end
end