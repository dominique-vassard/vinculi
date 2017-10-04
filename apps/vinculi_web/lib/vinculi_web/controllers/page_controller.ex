defmodule VinculiWeb.PageController do
  use VinculiWeb, :controller
  use Drab.Controller

  plug VinculiWeb.AuthorizationPlug when action in [:restrict_one,
                                                    :restrict_two,
                                                    :restrict_three]

  def index(conn, _params) do
    render conn, "index.html", page_name: "Index all access"
  end

  def restrict_one(conn, _params) do
    render conn, "index.html", page_name: "Restrict 1: at least Read"
  end

  def restrict_two(conn, _params) do
    render conn, "index.html", page_name: "Restrict 2: only Write"
  end

  def restrict_three(conn, _params) do
    render conn, "index.html", page_name: "Restrict 3: at least Admin"
  end
end
