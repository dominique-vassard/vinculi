defmodule VinculiWeb.ConstellationController do
  use VinculiWeb, :controller
  use Drab.Controller

  def index(conn, _params) do
    labels = VinculiGraph.Meta.list_labels()

    render conn, "index.html", labels: labels, fields: []
  end

  def search(conn, %{"search" => node_form_params} = params) do
    IO.puts inspect params
    # node_params = for {key, val} <- node_form_params, into: %{}
    #   {String.to_atom(key), val}
    # end
    VinculiGraph.Meta.get_fuzzy_node_by(node_form_params)
    # labels = VinculiGraph.Meta.list_labels()
    # results = []
    # render conn, "index.html", labels: labels,
    #        fields: Helpers.get_non_id_fields(label)
    text conn, "yeap"
  end
end
