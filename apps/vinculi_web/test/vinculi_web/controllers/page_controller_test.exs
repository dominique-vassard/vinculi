defmodule VinculiWeb.PageControllerTest do
  use VinculiWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 302)
  end
end
