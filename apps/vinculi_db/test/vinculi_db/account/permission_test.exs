defmodule VinculiDb.Account.PermissionTest do
  use VinculiDb.DataCase, async: true

  alias VinculiDb.Account.Permission

  @valid_attrs %{name: "new Permission"}

  describe "changeset/2" do
    test "test valid data" do
      changeset = Permission.changeset(%Permission{}, @valid_attrs)

      assert changeset.valid?
    end

    test ":name should be at least 3 characters long" do
      attrs = Map.put(@valid_attrs, :name, "Oi")
      changeset = Permission.changeset(%Permission{}, attrs)

      refute changeset.valid?
      assert {:name, {"should be at least %{count} character(s)",
                      [count: 3, validation: :length, min: 3]}}
             in changeset.errors
    end

    test ":name should be at most 40 characters long" do
      attrs = Map.put(@valid_attrs, :name, String.duplicate("a", 41))
      changeset = Permission.changeset(%Permission{}, attrs)

      refute changeset.valid?
      assert {:name, {"should be at most %{count} character(s)",
                      [count: 40, validation: :length, max: 40]}}
             in changeset.errors
    end
  end
end