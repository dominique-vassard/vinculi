defmodule VinculiWeb.Coherence.PasswordControllerTest do
  use VinculiWeb.ConnCase, async: true

  test "Requires authentication on :show, :edit, :update, :delete", %{conn: conn} do
    routes = [
              get(conn, password_path(conn, :edit, 123))
              # patch(conn, password_path(conn, :update, 123))
             ]
    check_authentication_required_routes(routes)
  end

  test "Does not require authentication on :new, :create, :edit, :update", %{conn: conn} do
    routes = [get(conn, password_path(conn, :new)),
              # post(conn, registration_path(conn, :create)),
            ]
    check_public_routes(routes)
  end
end