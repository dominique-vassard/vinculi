defmodule VinculiWeb.Coherence.RegistrationViewtest do
  use VinculiWeb.ConnCase, async: true
  import Phoenix.View

  alias VinculiDb.Coherence.Schemas
  alias Coherence.ControllerHelpers

  describe "Test with locale" do
    setup [:setup_locale]

    @tag locale: "fr"
    test "GET /registrations/new", %{conn: conn} do

      content = render_to_string(VinculiWeb.Coherence.RegistrationView,
                                 "new.html", conn: conn,
                                 changeset: Schemas.change_user())
      assert String.contains? content, "Prénom"
      assert String.contains? content, "Nom"
      assert String.contains? content, "Email"
      assert String.contains? content, "Mot de passe"
      assert String.contains? content, "Confirmation du mot de passe"
      assert String.contains? content, "S&#39;inscrire"
      assert String.contains? content, "Annuler"
    end
  end

  describe "Test with locale and logger user" do
    setup [:setup_locale, :setup_login]

    @tag locale: "fr", login: true
    test "GET /registrations", %{conn: conn, user: user} do
      content = render_to_string(VinculiWeb.Coherence.RegistrationView,
                                 "show.html", conn: conn, user: user,
                                 changeset: Schemas.change_user())
      assert String.contains? content, "Prénom"
      assert String.contains? content, "Nom"
      assert String.contains? content, "Email"
      assert String.contains? content, "Modifier"
      assert String.contains? content, "Supprimer"
    end

    @tag locale: "fr", login: true
    test "GET /registrations/edit", %{conn: conn, user: user} do
      changeset = ControllerHelpers.changeset(:registration,
                                              user.__struct__, user)
      content = render_to_string(VinculiWeb.Coherence.RegistrationView,
                                 "edit.html", conn: conn, user: user,
                                 changeset: changeset)
      assert String.contains? content, "Prénom"
      assert String.contains? content, "Nom"
      assert String.contains? content, "Email"
      assert String.contains? content, "Mot de passe"
      assert String.contains? content, "Mot de passe actuel"
      assert String.contains? content, "Confirmation du mot de passe"
      assert String.contains? content, "Mettre à jour"
      assert String.contains? content, "Annuler"
    end
  end
end