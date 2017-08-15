defmodule VinculiDb.Coherence.User do
  @moduledoc false
  use Ecto.Schema
  use Coherence.Schema

  @user_required_fields ~w(first_name last_name email)

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    coherence_schema()

    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> user_changeset(params)
    |> cast(params, coherence_fields())
    |> validate_password()
    |> validate_coherence(params)
  end

  def user_changeset(model, params) do
    email_regex = ~r/^[\w-+.]+@[a-z0-9-]+\.[a-z]+(\.{1}[a-z]+)?$/i
    model
    |> cast(params,  @user_required_fields)
    |> validate_required(Enum.map @user_required_fields, &String.to_atom/1)
    |> validate_length(:first_name, min: 3, max: 40)
    |> validate_length(:last_name, min: 3, max: 40)
    |> validate_format(:email, email_regex)
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email)
  end

  def changeset(model, params, :password) do
    model
    |> cast(params, ~w(password password_confirmation reset_password_token reset_password_sent_at))
    |> validate_coherence_password_reset(params)
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
