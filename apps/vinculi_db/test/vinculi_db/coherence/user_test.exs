defmodule VinculiDb.Coherence.UserTest do
  use VinculiDb.DataCase, async: true
  import VinculiDb.UserTestHelpers
  alias VinculiDb.Coherence.User

  @valid_user_attrs %{first_name: "John", last_name: "Duff",
                      email: "john.duff@email.com", pass: "Str0ng!On3",
                      pass_confirmation: "Str0ng!On3"}

  # Testing email
  describe "Test email:" do
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
      changeset = User.user_changeset(%User{}, attrs)

      assert changeset.valid?
      assert changeset.changes.email == String.downcase(cased_email)
    end
  end

  # Testing first name and last name
  describe "Testing failing user changeset:" do
    test "user changeset with invalid attributes" do
      changeset = User.user_changeset(%User{}, %{})
      refute changeset.valid?
    end

    test "first_name should be at least 3 chars long" do
      attrs = Map.put(@valid_user_attrs, :first_name, "Oi")
      changeset = User.user_changeset(%User{}, attrs)

      refute changeset.valid?
      assert {:first_name, {"should be at least %{count} character(s)",
                            [count: 3, validation: :length, min: 3]}}
             in changeset.errors
    end

    test "first_name should be less 40 chars long" do
      attrs = Map.put(@valid_user_attrs, :first_name, String.duplicate("a", 50))
      changeset = User.user_changeset(%User{}, attrs)

      refute changeset.valid?
      assert {:first_name, {"should be at most %{count} character(s)",
                            [count: 40, validation: :length, max: 40]}}
             in changeset.errors
    end

    test "last_name should be at least 3 chars long" do
      attrs = Map.put(@valid_user_attrs, :last_name, "Oi")
      changeset = User.user_changeset(%User{}, attrs)

      refute changeset.valid?
      assert {:last_name, {"should be at least %{count} character(s)",
                            [count: 3, validation: :length, min: 3]}}
             in changeset.errors
    end

    test "last_name should be less 40 chars long" do
      attrs = Map.put(@valid_user_attrs, :last_name, String.duplicate("a", 50))
      changeset = User.user_changeset(%User{}, attrs)

      refute changeset.valid?
      assert {:last_name, {"should be at most %{count} character(s)",
                            [count: 40, validation: :length, max: 40]}}
             in changeset.errors
    end
  end

  # Test password check
  describe "Check password:" do
    test "password should contain at least one lowercase character" do
      attrs = Map.put(@valid_user_attrs, :password, "N0LOWERC4SE!")
      changeset =
        change(%User{}, attrs)
        |> User.validate_password()

      refute changeset.valid?
      assert {:password, {"should contains at least one lowercase character.",
                      [validation: :format]}}
          in changeset.errors
    end

    test "password should contain at least one uppercase character" do
      attrs = Map.put(@valid_user_attrs, :password, "noupp3rc4se!")
      changeset =
        change(%User{}, attrs)
        |> User.validate_password()

      refute changeset.valid?
      assert {:password, {"should contains at least one uppercase character.",
                      [validation: :format]}}
          in changeset.errors
    end
    test "password should contain at least one digit" do
      attrs = Map.put(@valid_user_attrs, :password, "NoDigits!")
      changeset =
        change(%User{}, attrs)
        |> User.validate_password()

      refute changeset.valid?
      assert {:password, {"should contains at least one digit.",
                      [validation: :format]}}
          in changeset.errors
    end

    test "password should contain at least one special character" do
      attrs = Map.put(@valid_user_attrs, :password, "NoSpeci4alCh4r")
      changeset =
        change(%User{}, attrs)
        |> User.validate_password()

      refute changeset.valid?
      assert {:password, {"should contains at least one special character.",
                      [validation: :format]}}
          in changeset.errors
    end

    test "password should be at least 8 characters long" do
      attrs = Map.put(@valid_user_attrs, :password, "Sh0rt!")
      changeset =
        change(%User{}, attrs)
        |> User.validate_password()

      refute changeset.valid?
      assert {:password, {"should be at least %{count} character(s)",
                          [count: 8, validation: :length, min: 8]}}
        in changeset.errors
    end

    test "password should be less than 20 characters long" do
      attrs = Map.put(@valid_user_attrs, :password,
                      "Sh0rt!" <> String.duplicate("a", 20))
      changeset =
        change(%User{}, attrs)
        |> User.validate_password()


      refute changeset.valid?
      assert {:password, {"should be at most %{count} character(s)",
                             [count: 20, validation: :length, max: 20]}}
        in changeset.errors
    end
  end
end