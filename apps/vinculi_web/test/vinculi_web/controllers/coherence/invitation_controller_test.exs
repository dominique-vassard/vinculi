defmodule VinculiWeb.Coherence.InvitationControllerTest do
  use VinculiWeb.ConnCase, async: true

  test "Requires authentication on all routes", %{conn: conn} do
    routes = [get(conn, invitation_path(conn, :edit, 123)),
       # post(conn, invitation_path(conn, :create_user)),
       get(conn, invitation_path(conn, :new)),
       post(conn, invitation_path(conn, :create)),
       get(conn, invitation_path(conn, :resend, 123))]
    check_authentication_required_routes(routes)
  end

  describe "Test with logged users" do
    setup [:setup_login]

    @tag login: true
    test "GET /invitations/new", %{conn: conn, user: _user} do
      conn = get conn, invitation_path(conn, :new)
      assert html_response(conn, 200)
    end
  end
end