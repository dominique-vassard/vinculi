defmodule VinculiWeb.Coherence.UnlockViewtest do
  use VinculiWeb.ConnCase, async: true
  import Phoenix.View

  alias VinculiDb.Coherence.Schemas

  describe "Test with locale" do
    setup [:setup_locale]

    @tag locale: "fr"
    test "GET /unlocks/new", %{conn: conn} do
      content = render_to_string(VinculiWeb.Coherence.UnlockView,
                                 "new.html", conn: conn,
                                 changeset: Schemas.change_user())
      assert String.contains? content, "Email"
      assert String.contains? content, "Mot de passe"
      assert String.contains? content, "Envoyer les instructions"
      assert String.contains? content, "Annuler"
    end
  end
end