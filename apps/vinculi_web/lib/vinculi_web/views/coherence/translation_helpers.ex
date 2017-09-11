defmodule VinculiWeb.Coherence.TranslationHelpers do
  import VinculiWeb.Gettext

  def recover_link(), do: dgettext("coherence", "Forgot your password?")
  def unlock_link(), do: dgettext("coherence", "Send an unlock email")
  def register_link(), do: dgettext("coherence", "Need An Account?")
  def invite_link(), do: dgettext("coherence", "Invite Someone")
  def confirm_link(), do: dgettext("coherence", "Resend confirmation email")
  def signin_link(), do: dgettext("coherence", "Sign In")
  def signout_link(), do: dgettext("coherence", "Sign Out")
end