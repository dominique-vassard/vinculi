defmodule VinculiWeb.Coherence.ConfirmationViewtest do
  use VinculiWeb.ConnCase, async: true
  import Phoenix.View

  alias VinculiDb.Coherence.Schemas

  describe "Test with locale" do
    setup [:setup_locale]

    @tag locale: "fr"
    test "GET /confirmations/new", %{conn: conn} do
      content = render_to_string(VinculiWeb.Coherence.ConfirmationView,
                                 "new.html", conn: conn, email: "",
                                 changeset: Schemas.change_user())
      assert String.contains? content, "Email"
      assert String.contains? content, "Envoyer l&#39;email à nouveau"
      assert String.contains? content, "Annuler"
    end
  end
end