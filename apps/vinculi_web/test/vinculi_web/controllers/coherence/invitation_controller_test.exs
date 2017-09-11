defmodule VinculiWeb.Coherence.InvitationControllerTest do
  use VinculiWeb.ConnCase, async: true

  test "Requires authentication on all pages", %{conn: conn} do
    Enum.each(
      [get(conn, invitation_path(conn, :edit, 123)),
       # post(conn, invitation_path(conn, :create_user)),
       get(conn, invitation_path(conn, :new)),
       post(conn, invitation_path(conn, :create)),
       get(conn, invitation_path(conn, :resend, 123)),],
       fn conn ->
        assert html_response(conn, 302)
       end)
  end

  describe "Test with logged users" do
    setup [:setup_login]

    @tag login: true
    test "GET /invitations/new", %{conn: conn, user: _user} do

      conn = get conn, "/invitations/new"
      assert html_response(conn, 200)
    end
  end
end