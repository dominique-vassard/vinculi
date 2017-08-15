defmodule VinculiDb.UserTestHelpers do
  use ExUnit.CaseTemplate
  alias VinculiDb.Coherence.User

  @doc """
  Get changeset for the given email
  """
  def get_changeset_from_email(email, valid_attrs) do
    attrs = Map.put(valid_attrs, :email, email)
    User.user_changeset(%User{}, attrs)
  end

  @doc """
  Check the email validity
  """
  def check_valid_email(email, valid_attrs) do
    changeset = get_changeset_from_email(email, valid_attrs)

    assert changeset.valid?
  end

  @doc """
  Check the email invalidity
  """
  def check_invalid_email(email, valid_attrs) do
    changeset = get_changeset_from_email(email, valid_attrs)

    refute changeset.valid?
    assert {:email, {"has invalid format", [validation: :format]}}
    in changeset.errors
  end
end