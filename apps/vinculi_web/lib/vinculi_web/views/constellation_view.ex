defmodule VinculiWeb.ConstellationView do
  use VinculiWeb, :view

  @doc """
    Retrieves a CSRF token.
  """
  def get_csrf_token() do
    {mod, fun, args} = Application.fetch_env!(:phoenix_html, :csrf_token_generator)
    apply(mod, fun, args)
  end

  @doc """
    Tranform a camelCase atom into a label.

    ## Example:
        iex> VinculiWeb.ConstellationView.to_label :firstName
        "First name"
  """
  def to_label(word) do
    word
    |> to_string()
    |> String.replace(~r/([A-Z]+)([A-Z][a-z])/, "\\1 \\2")
    |> String.replace(~r/([a-z\d])([A-Z])/, "\\1 \\2")
    |> String.replace(~r/_/, " ")
    |> String.downcase
    |> String.capitalize()
  end
end