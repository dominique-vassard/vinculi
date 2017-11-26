defmodule Utils.Struct do
  @moduledoc """
    Utilities that works on struct (map, list, etc.)
  """

  @doc """
  Transform a string map in a keyword map.
  Works with nested maps.

  ## Example / Usage
      iex> Utils.Struct.to_atom_map %{"first" => 1, "second" => "two"}
      %{first: 1, second: "two"}

      iex> Utils.Struct.to_atom_map %{"first" => 1, second: "two"}
      %{first: 1, second: "two"}

      iex> map = %{"first" => 1, "nested" => %{"second" => "two"}}
      iex> Utils.Struct.to_atom_map map
      %{first: 1, nested: %{second: "two"}}

  """
  def to_atom_map(map) do
    Enum.into(map, %{}, &do_to_atom/1)
  end

  defp do_to_atom({key, value}) when is_map(value) do
    {key_to_atom(key), to_atom_map(value)}
  end

  defp do_to_atom({key, value}) when is_atom(key) do
    {key, value}
  end

  defp do_to_atom({key, value}) when is_binary(key) do
    {key_to_atom(key), value}
  end

  defp key_to_atom(key) when is_binary(key) do
   String.to_atom(key)
  end

  defp key_to_atom(key) do
    key
  end
end