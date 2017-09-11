defmodule VinculiWeb.Coherence.InvitationViewtest do
  use VinculiWeb.ConnCase, async: true
  import Phoenix.View

  alias VinculiDb.Coherence.Schemas

  describe "Test with locale" do
    setup [:setup_locale, :setup_login]

    @tag locale: "fr", login: true
    test "GET /invitations/new", %{conn: conn, user: _user} do

      conn = get conn, "/invitations/new"
      assert html_response(conn, 200)
      content = render_to_string(VinculiWeb.Coherence.InvitationView,
                                 "new.html", conn: conn,
                                 changeset: Schemas.change_invitation())
      assert String.contains? content, "Prénom"
      assert String.contains? content, "Nom"
      assert String.contains? content, "Email"
    end
  end
end