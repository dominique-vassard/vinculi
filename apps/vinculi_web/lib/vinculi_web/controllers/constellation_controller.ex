defmodule VinculiWeb.ConstellationController do
  use VinculiWeb, :controller
  use Drab.Controller

  alias VinculiGraph.Helpers

  def index(conn, _params) do
    labels = VinculiGraph.Meta.list_labels()

    render conn, "index.html", labels: labels, fields: []
  end

  def search(conn, %{"label" => label} = params) do
    IO.puts inspect params
    # labels = VinculiGraph.Meta.list_labels()
    # results = []
    # render conn, "index.html", labels: labels,
    #        fields: Helpers.get_non_id_fields(label)
    conn
  end
end
