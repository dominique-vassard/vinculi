defmodule VinculiDb.Coherence.Invitation do
  @moduledoc """
  Schema to support inviting a someone to create an account.
  """
  use Ecto.Schema

  alias VinculiDb.Coherence.Helpers

  schema "invitations" do
    field :first_name, :string
    field :last_name, :string
    field :name, :string
    field :email, :string
    field :token, :string

    timestamps()
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  @spec changeset(Ecto.Schema.t, Map.t) :: Ecto.Changeset.t
  def changeset(model, params \\ %{}) do
    model
    |> Helpers.user_changeset(params)
  end

  @doc """
  Creates a changeset for a new schema
  """
  @spec new_changeset(Map.t) :: Ecto.Changeset.t
  def new_changeset(params \\ %{}) do
    changeset %__MODULE__{}, params
  end
end
