defmodule VinculiDb.Coherence.InvitationTest do
  use VinculiDb.DataCase, async: true
  alias VinculiDb.Coherence.Invitation

  @valid_invitation_attrs %{first_name: "John", last_name: "Duff",
                      email: "john.duff@email.com"}

  # Test changeset
  describe "Test changeset/2:" do
    test "Valid values provides a valid changeset" do
      changeset = Invitation.changeset(%Invitation{}, @valid_invitation_attrs)

      assert changeset.valid?
    end

    test "Invalid values returns an invalid changeset" do
      attrs = Map.put(@valid_invitation_attrs, :first_name, "")

      changeset = Invitation.changeset(%Invitation{}, attrs)

      refute changeset.valid?
    end
  end
end