defmodule VinculiWeb.LayoutView do
  use VinculiWeb, :view
  import VinculiWeb.Coherence.ViewHelpers

  def account_menu(%{assigns: %{current_user: nil}} = conn) do
    render(__MODULE__, "menu_no_user.html", conn: conn)
  end

  def account_menu(%{assigns: %{current_user: _user}} = conn) do
    render(__MODULE__, "menu_user.html", conn: conn)
  end
end
