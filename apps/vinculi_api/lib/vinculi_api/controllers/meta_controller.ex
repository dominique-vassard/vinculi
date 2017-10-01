defmodule VinculiApi.MetaController do
  use VinculiApi, :controller
  alias VinculiGraph.Meta

  def labels(conn, _params) do
    json conn, Meta.list_labels()
  end
end