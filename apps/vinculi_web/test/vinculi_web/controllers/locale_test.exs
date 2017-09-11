defmodule VinculiWeb.LocaleTest do
  use VinculiWeb.ConnCase
  alias VinculiWeb.Router

  @fallback_locale Application.get_env(:vinculi_web, :fallback_locale)

  setup %{conn: conn} do
    conn = conn
    |> bypass_through(Router, :browser)

    {:ok, %{conn: conn}}
  end

  test "locale set to fr when access /", %{conn: conn} do
    get conn, "/"

    assert Gettext.get_locale(VinculiWeb.Gettext) == @fallback_locale
  end
end