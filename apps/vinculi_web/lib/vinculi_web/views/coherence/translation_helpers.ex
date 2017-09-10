defmodule VinculiWeb.Coherence.TranslationHelpers do
  import VinculiWeb.Gettext

  def recover_link() do
    a = dgettext("coherence", "Forgot your password?")
    IO.puts "help Locale => #{Gettext.get_locale(VinculiWeb.Gettext)}"
    IO.puts "help Recover link: #{a}"
    a
  end
  def unlock_link(), do: dgettext("coherence", "Send an unlock email")
  def register_link(), do: dgettext("coherence", "Need An Account?")
  def invite_link(), do: dgettext("coherence", "Invite Someone")
  def confirm_link(), do: dgettext("coherence", "Resend confirmation email")
  def signin_link(), do: dgettext("coherence", "Sign In")
  def signout_link(), do: dgettext("coherence", "Sign Out")
end