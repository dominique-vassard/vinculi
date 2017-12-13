defmodule VinculiApi.MetaController do
  use VinculiApi, :controller
  alias VinculiGraph.Node

  def labels(conn, _params) do
    json conn, Node.get_labels()
  end
end