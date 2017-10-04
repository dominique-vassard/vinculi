defmodule VinculiWeb.ConstellationView do
  use VinculiWeb, :view

  def get_csrf_token() do
    {mod, fun, args} = Application.fetch_env!(:phoenix_html, :csrf_token_generator)
    apply(mod, fun, args)
  end

  def to_label(snake_label) do
    snake_label
    |> to_string()
    |> String.replace("_", " ")
    |> String.capitalize()
  end
end