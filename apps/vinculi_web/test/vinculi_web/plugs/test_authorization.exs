defmodule VinculiWeb.TestAuthorization do
  use VinculiWeb.ConnCase

  alias VinculiWeb.AuthorizationPlug
  import Plug.Conn

  describe "Test call/2" do
    setup [:setup_login]

    @tag login: %{role_name: "Administrator"}
    test "Access to ['Read'] page should be ok for an 'Administrator'", %{conn: conn} do
      n_conn = conn
      |> put_private(:phoenix_controller, VinculiWeb.PageController)
      |> put_private(:phoenix_action, :restrict_one)
      f_conn = AuthorizationPlug.call(n_conn, [])
    end

    @tag login: %{role_name: "Reader"}
    test "Access to ['Write'] page should be ok for an 'Reader'", %{conn: conn} do
      last_conn = get(conn, page_path(conn, :restrict_two))
      assert html_response(last_conn, 302)
    end

    @tag login: true
    test "Access to non-defined perms page should be redirection", %{conn: conn} do
      last_conn = get(conn, page_path(conn, :restrict_three))
      assert html_response(last_conn, 302)
    end
  end

end