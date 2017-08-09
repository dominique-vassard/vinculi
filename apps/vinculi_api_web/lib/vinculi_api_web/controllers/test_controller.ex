defmodule VinculiApiWeb.TestController do
  use VinculiApiWeb, :controller

  def index(conn, _params) do
    json conn, %{test: "ok"}
  end
end