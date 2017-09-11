defmodule VinculiWeb.Coherence.PasswordViewtest do
  use VinculiWeb.ConnCase, async: true
  import Phoenix.View

  alias VinculiDb.Coherence.Schemas

  describe "Test with locale" do
    setup [:setup_locale]

    @tag locale: "fr"
    test "GET /passwords/new", %{conn: conn} do
      content = render_to_string(VinculiWeb.Coherence.PasswordView,
                                 "new.html", conn: conn, email: "",
                                 changeset: Schemas.change_user())
      assert String.contains? content, "Email"
      assert String.contains? content, "Réinitialiser le mot de passe"
      assert String.contains? content, "Annuler"
    end
  end

  describe "Test with locale and logger user" do
    setup [:setup_locale, :setup_login]

    @tag locale: "fr", login: true
    test "GET /passwords/edit", %{conn: _conn, user: user} do
      conn = get(build_conn(),
                 password_path(build_conn(), :edit, user.reset_password_token))
      content = html_response(conn, 200)

      # content = render_to_string(VinculiWeb.Coherence.PasswordView,
      #                            "edit.html", conn: conn,
      #                            changeset: Schemas.change_user())
      assert String.contains? content, "Mot de passe"
      assert String.contains? content, "Confirmation du mot de passe"
      assert String.contains? content, "Mettre à jour le mot de passe"
      assert String.contains? content, "Annuler"
    end
  end
end