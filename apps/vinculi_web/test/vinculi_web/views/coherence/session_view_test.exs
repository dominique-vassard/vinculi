defmodule VinculiWeb.Coherence.SessionViewtest do
  use VinculiWeb.ConnCase, async: true
  import Phoenix.View

  describe "Test with locale" do
    setup [:setup_locale]

    @tag locale: "fr"
    test "GET /session/new", %{conn: conn} do

      content = render_to_string(VinculiWeb.Coherence.SessionView,
                                 "new.html", conn: conn, remember: false)
      assert String.contains? content, "Email"
      assert String.contains? content, "Mot de passe"
      assert String.contains? content, "Mot de passe oublié?"
      assert String.contains? content, "S&#39;inscrire"
    end
  end
end