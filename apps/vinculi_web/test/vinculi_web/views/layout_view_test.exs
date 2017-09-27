defmodule VinculiWeb.LayoutViewTest do
  use VinculiWeb.ConnCase, async: true
  import Phoenix.View
  import VinculiWeb.Gettext

  describe "Test menu (unauthenticated) with locale" do
    setup [:setup_locale]

    @tag locale: "fr"
    test "GET /sessions/new : check menu without user", %{conn: conn} do
      content = render_to_string(VinculiWeb.LayoutView,
                                 "menu_no_user.html",
                                 conn: conn)
      assert String.contains? content, dgettext("coherence", "Sign In")
      assert String.contains? content, "S&#39;inscrire"
      # assert String.contains? content, dgettext("coherence", "Need an account?")
    end
  end

  describe "Test menu (authenticated) with locale" do
    setup [:setup_locale, :setup_login]

    @tag login: true, locale: "fr"
    test "GET /sessions/new : check menu with user", %{conn: conn} do
      content = render_to_string(VinculiWeb.LayoutView,
                                 "menu_user.html",
                                 conn: conn)
      assert String.contains? content, dgettext("coherence", "Invite Someone")
      assert String.contains? content, dgettext("coherence", "Show account")
      assert String.contains? content, dgettext("coherence", "Sign Out")
    end
  end
end
