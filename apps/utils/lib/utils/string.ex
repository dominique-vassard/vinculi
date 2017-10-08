defmodule Utils.String do
  @moduledoc """
    Utilities that works on struct (map, list, etc.)
  """

  # def atom_to_came do

  # end

  @doc """
  Camelize a snakecase string.

  ## Examples/ Usage:
      iex> Utils.String.camelize "snake_case"
      "snakeCase"

      iex> Utils.String.camelize "nonsnake"
      "nonsnake"

      iex> Utils.String.camelize "misFormed_snake_is_reformed"
      "misformedSnakeIsReformed"
  """
  def camelize(str) when is_binary str do
    str
    |> String.split("_")
    |> Enum.map(&String.downcase/1)
    |> finish_camelize()
  end

  def camelize(str) when is_atom str do
    camelize to_string(str)
  end

  defp finish_camelize([first | rest]) do
    rest
    |> Enum.map(&String.capitalize/1)
    |> List.insert_at(0, String.downcase first)
    |> Enum.join()
  end
end