defmodule VinculiWeb.ConstellationCommander do
  use Drab.Commander

  alias VinculiGraph.Helpers
  alias VinculiGraph.Node

  @doc """
    List search field for the given node label
  """
  def update_fields(socket, sender) do
    %{"search" => %{"label" => label}} = sender.params
    poke socket, fields: Helpers.get_name_fields(label), results: []
  end

  @doc """
    Launch and display search result
  """
  def search(socket, sender) do
    %{"search" => %{"properties" => properties} = node_form_params
      } = sender.params

    nb_changes = properties
    |> Enum.filter(fn {_, value} -> String.length(value) >= 1 end)
    |> length()

    results = cond do
      nb_changes >= 1 ->
        Node.get_fuzzy_by(Utils.Struct.to_atom_map node_form_params)
        |> Enum.map(&VinculiGraph.Helpers.get_name/1)
       true ->
        []
    end

    poke socket, results: results
  end
end