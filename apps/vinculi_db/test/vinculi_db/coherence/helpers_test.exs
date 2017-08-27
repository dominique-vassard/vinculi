defmodule VinculiDb.Coherence.HelpersTest do
  use VinculiDb.DataCase, async: true
  import VinculiDb.UserTestHelpers
  alias VinculiDb.Coherence.Helpers
  alias VinculiDb.Coherence.User

  @valid_user_attrs %{first_name: "John", last_name: "Duff",
                      email: "john.duff@email.com", pass: "Str0ng!On3",
                      pass_confirmation: "Str0ng!On3"}

  # Test user_changeset/2
  describe "test user_changeset/2:" do
    test "email should not accept invalid format" do
      emails = ["ugl:yemail@wrongformat", "@missing-part1.com", "missing-part12",
               "missing@part3", "invalid@c_h_a_r", "invalid@dom.co;uk",
               "invalid@dom.co..uk"]
      Enum.map(emails, &(check_invalid_email(&1, @valid_user_attrs)))
    end

    test "email should accept valid format" do
      emails = ["email@domain.com", "named_email@domain.com", "email@dom.co.uk",
               "email-hyphen@domain.com", "email+plus@domain.com", "c9@dom9.com",
               "email@dom-ain.co.uk"]
      Enum.map(emails, &(check_valid_email(&1, @valid_user_attrs)))
    end

    test "email should be downcased" do
      cased_email = "CAsed_EmaIl@DOmAin.COm"
      attrs = Map.put(@valid_user_attrs, :email, cased_email)
      changeset = Helpers.user_changeset(%User{}, attrs)

      assert changeset.valid?
      assert changeset.changes.email == String.downcase(cased_email)
    end

    test "user changeset with invalid attributes" do
      changeset = Helpers.user_changeset(%User{}, %{})
      refute changeset.valid?
    end

    test "first_name should be at least 3 chars long" do
      attrs = Map.put(@valid_user_attrs, :first_name, "Oi")
      changeset = Helpers.user_changeset(%User{}, attrs)

      refute changeset.valid?
      assert {:first_name, {"should be at least %{count} character(s)",
                            [count: 3, validation: :length, min: 3]}}
             in changeset.errors
    end

    test "first_name should be less 40 chars long" do
      attrs = Map.put(@valid_user_attrs, :first_name, String.duplicate("a", 50))
      changeset = Helpers.user_changeset(%User{}, attrs)

      refute changeset.valid?
      assert {:first_name, {"should be at most %{count} character(s)",
                            [count: 40, validation: :length, max: 40]}}
             in changeset.errors
    end

    test "last_name should be at least 3 chars long" do
      attrs = Map.put(@valid_user_attrs, :last_name, "Oi")
      changeset = Helpers.user_changeset(%User{}, attrs)

      refute changeset.valid?
      assert {:last_name, {"should be at least %{count} character(s)",
                            [count: 3, validation: :length, min: 3]}}
             in changeset.errors
    end

    test "last_name should be less 40 chars long" do
      attrs = Map.put(@valid_user_attrs, :last_name, String.duplicate("a", 50))
      changeset = Helpers.user_changeset(%User{}, attrs)

      refute changeset.valid?
      assert {:last_name, {"should be at most %{count} character(s)",
                            [count: 40, validation: :length, max: 40]}}
             in changeset.errors
    end
  end

  # Test put_name function
  test "put_name/1 adds a computed name to changeset" do
    changeset = change(%User{}, @valid_user_attrs)
    |> Helpers.put_name()
    %{first_name: first_name, last_name: last_name} = @valid_user_attrs

    assert changeset.valid?
    assert {:name, first_name <> " " <> last_name}
      in changeset.changes
  end
end