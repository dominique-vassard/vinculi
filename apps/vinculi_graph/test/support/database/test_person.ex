defmodule VinculiGraph.TestPerson do
  @moduledoc """
  Test model for database tests
  """
  use Ecto.Schema

  import Ecto.Changeset

  schema "TestPerson" do
    field :uuid, :string
    field :lastName, :string
    field :firstName, :string
    field :aka, :string
    field :internalLink, :string
    field :externalLink, :string
  end

  @required_fields ~w(lastName firstName)
  @optional_fields ~w(uuid aka internalLink externalLink)

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(Enum.map @required_fields, &String.to_atom/1)
    |> validate_length(:lastName, min: 2, max: 50)
    |> validate_length(:firstName, min: 2, max: 50)
  end
end