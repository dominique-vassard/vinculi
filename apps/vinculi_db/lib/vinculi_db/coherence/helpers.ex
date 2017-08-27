defmodule VinculiDb.Coherence.Helpers do
  import Ecto.Changeset

  @user_required_fields ~w(first_name last_name email)

  @doc """
    User changeset.
    Validates:
      - first name
      - last name
      - email
  """
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
    |> put_name()
  end

  @doc """
    As name is required by Coherence, this function computes one by concatening
    first name and last name
  """
  def put_name(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{first_name: first_name, last_name: last_name}} ->
        put_change(changeset, :name, first_name <> " " <> last_name)
      _ ->
        changeset
    end
  end
end