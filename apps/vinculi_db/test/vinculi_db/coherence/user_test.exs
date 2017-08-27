defmodule VinculiDb.Coherence.UserTest do
  use VinculiDb.DataCase, async: true
  alias VinculiDb.Coherence.User

  @valid_user_attrs %{first_name: "John", last_name: "Duff",
                      email: "john.duff@email.com", password: "Str0ng!On3",
                      password_confirmation: "Str0ng!On3"}

  # Test changeset
  describe "Test changeset/2:" do
    test "Valid values provides a valid changeset" do
      changeset = User.changeset(%User{}, @valid_user_attrs)

      assert changeset.valid?
    end

    test "Invalid values returns an invalid changeset" do
      attrs = Map.put(@valid_user_attrs, :first_name, "")

      changeset = User.changeset(%User{}, attrs)

      refute changeset.valid?
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