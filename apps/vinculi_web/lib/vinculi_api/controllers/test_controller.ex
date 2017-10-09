defmodule VinculiApi.TestController do
  use VinculiApi, :controller

  def index(conn, _params) do
    json conn, %{test: "ok"}
  end
end