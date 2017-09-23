defmodule VinculiDb.Coherence.User do
  @moduledoc """
    Coherence user schema, augmented for the Vinculi needs

    fields are:
      - first_name  (string)  3 < nb characters < 40
      - last_name   (string)  3 < nb characters < 40
      - email       (string)  must be valid, is unique
      - password    (string)  must cotain at least 1 uppercase char, 1
        lowercase char, 1 digit and 1 special char
      - role_id     (int)     reelated to roles.id
  """
  use Ecto.Schema
  use Coherence.Schema

  alias VinculiDb.Coherence.Helpers

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :name, :string
    field :email, :string
    coherence_schema()
    belongs_to :role, VinculiDb.Account.Role

    timestamps()
  end

  @doc """
    Initial changeset.
    Requires:
      - first name
      - last name
      - email
      - password
      - password confirmation
  """
  def changeset(model, params \\ %{}) do
    model
    |> Helpers.user_changeset(params)
    |> cast(params, coherence_fields())
    |> validate_password()
    |> validate_coherence(params)
  end

  @doc """
    Password changeset.
    Validates password
  """
  def changeset(model, params, :password) do
    model
    |> cast(params, ~w(password password_confirmation reset_password_token reset_password_sent_at))
    |> validate_coherence_password_reset(params)
  end

  @doc """
  Computes password hash from pass
  """
  def put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{pass: pass}} ->
        put_change(changeset, :password, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end

  @doc """
  Check the password validity

  Password should contain:
  - at least one lowercase character
  - at least one uppercase character
  - at least one digit
  - at least one special character
  """
  def validate_password(changeset) do
    changeset
    |> validate_length(:password, min: 8, max: 20)
    |> validate_format(:password, ~r/[a-z]/,
          [message: "should contains at least one lowercase character."])
    |> validate_format(:password, ~r/[A-Z]/,
          [message: "should contains at least one uppercase character."])
    |> validate_format(:password, ~r/[\d]/,
          [message: "should contains at least one digit."])
    |> validate_format(:password, ~r/[\W_]/,
          [message: "should contains at least one special character."])
  end
end
