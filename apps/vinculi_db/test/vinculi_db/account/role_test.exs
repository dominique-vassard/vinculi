defmodule VinculiDb.Account.RoleTest do
  use VinculiDb.DataCase, async: true

  alias VinculiDb.Account.Role

  @valid_attrs %{name: "new Role"}

  describe "changeset/2" do
    test "test valid data" do
      changeset = Role.changeset(%Role{}, @valid_attrs)

      assert changeset.valid?
    end

    test ":name should be at least 3 characters long" do
      attrs = Map.put(@valid_attrs, :name, "Oi")
      changeset = Role.changeset(%Role{}, attrs)

      refute changeset.valid?
      assert {:name, {"should be at least %{count} character(s)",
                      [count: 3, validation: :length, min: 3]}}
             in changeset.errors
    end

    test ":name should be at most 40 characters long" do
      attrs = Map.put(@valid_attrs, :name, String.duplicate("a", 41))
      changeset = Role.changeset(%Role{}, attrs)

      refute changeset.valid?
      assert {:name, {"should be at most %{count} character(s)",
                      [count: 40, validation: :length, max: 40]}}
             in changeset.errors
    end
  end
end