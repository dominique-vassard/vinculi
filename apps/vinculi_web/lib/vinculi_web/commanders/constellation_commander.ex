defmodule VinculiWeb.ConstellationCommander do
  use Drab.Commander

  alias VinculiGraph.Helpers

  @doc """
    get node fields from label
  """
  def update_fields(socket, sender) do
    %{"search" => %{"label" => label}} = sender.params
     poke socket, fields: Helpers.get_non_id_fields(label)
  end
end