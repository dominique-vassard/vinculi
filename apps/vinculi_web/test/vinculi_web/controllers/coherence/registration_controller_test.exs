defmodule VinculiWeb.Coherence.RegitrationControllerTest do
  use VinculiWeb.ConnCase, async: true

  test "Requires authentication on :show, :edit, :update, :delete", %{conn: conn} do
    routes = [get(conn, registration_path(conn, :show)),
              get(conn, registration_path(conn, :edit)),
              put(conn, registration_path(conn, :update)),
              patch(conn, registration_path(conn, :update)),
              delete(conn, registration_path(conn, :delete))]
    check_authentication_required_routes(routes)
  end

  test "Does not require authentication on :new, :create", %{conn: conn} do
    routes = [get(conn, registration_path(conn, :new)),
              # post(conn, registration_path(conn, :create))
            ]
    check_public_routes(routes)
  end
end