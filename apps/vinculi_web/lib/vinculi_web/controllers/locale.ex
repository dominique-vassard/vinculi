defmodule VinculiWeb.Locale do
  @moduledoc """
    A plug to handle locale

    `fallback_locale` should be found in config.exs

    Because the website needs to be only in french for now, this plug only set
    locale to 'fr'
  """
  import Plug.Conn

  @fallback_locale Application.get_env(:vinculi_web, :fallback_locale)

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    # For now, site is exclusively in french
    locale = @fallback_locale

    Gettext.put_locale(VinculiWeb.Gettext, locale)

    # Because of coherence translation, force VinculiDb locale
    Gettext.put_locale(VinculiDb.Gettext, locale)

    conn
    |> put_session(:locale, locale)
  end
end