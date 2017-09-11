defmodule VinculiWeb.Coherence.UnlockControllerTest do
  use VinculiWeb.ConnCase, async: true

  test "Requires authentication on :show, :edit, :update, :delete", %{conn: conn} do
    routes = [
              get(conn, unlock_path(conn, :edit, 123))
             ]
    check_authentication_required_routes(routes)
  end

  test "Does not require authentication on :new, :create, :edit", %{conn: conn} do
    routes = [get(conn, unlock_path(conn, :new)),
              # post(conn, unlock_path(conn, :create)),
            ]
    check_public_routes(routes)
  end
end