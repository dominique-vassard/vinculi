defmodule VinculiWeb.Coherence.SessionControllerTest do
  use VinculiWeb.ConnCase, async: true

  test "Requires authentication on :delete", %{conn: conn} do
    routes = [delete(conn, session_path(conn, :delete))]
    check_authentication_required_routes(routes)
  end

  test "Does not require authentication on :new, :create", %{conn: conn} do
    routes = [get(conn, session_path(conn, :new)),
              # post(conn, session_path(conn, :create))
            ]
    check_public_routes(routes)
  end
end