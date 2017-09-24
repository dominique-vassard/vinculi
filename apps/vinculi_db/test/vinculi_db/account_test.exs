defmodule VinculiDb.AccountTest do
  use VinculiDb.DataCase, async: true
  alias VinculiDb.Account
  alias VinculiDb.Account.Role
  alias VinculiDb.Account.Permission

  def role_fixture do
    Repo.insert! %Role{name: "Test role"}
  end

  def permission_fixture do
    Repo.insert! %Permission{name: "Test permission"}
  end

  test "change_role/1 returns a Ecto changeset" do
    assert %Ecto.Changeset{} = Account.change_role(%Role{})
  end

  describe "Test get_role/2:" do
    test "without option returns a Role without Permissions" do
      role = role_fixture()
      assert %Role{id: role_id, permissions: permissions} =
        Account.get_role role.id
      assert role_id == role.id
      refute is_list permissions
    end

    test "with :with_permissions returns a Role with all Permissions" do
      role = role_fixture()
      assert %Role{id: role_id, permissions: permissions} =
        Account.get_role role.id, :with_permissions
      assert role_id == role.id
      assert is_list permissions
    end
  end

  describe "Test get_role_by/2:" do
    test "without option returns a Role without Permissions" do
      role = role_fixture()
      assert %Role{id: role_id, permissions: permissions} =
        Account.get_role_by %{name: role.name}
      assert role_id == role.id
      refute is_list permissions
    end

    test "with :with_permissions returns a Role with all Permissions" do
      role = role_fixture()
      assert %Role{id: role_id, permissions: permissions} =
        Account.get_role_by %{name: role.name}, :with_permissions
      assert role_id == role.id
      assert is_list permissions
    end
  end

  test "change_permission/1 returns a Ecto changeset" do
    assert %Ecto.Changeset{} = Account.change_permission(%Permission{})
  end

  describe "Test get_permission/2:" do
    test "without option returns a Permission without Roles" do
      permission = permission_fixture()
      assert %Permission{id: permission_id, roles: roles} =
        Account.get_permission permission.id
      assert permission_id == permission.id
      refute is_list roles
    end

    test "with :with_roles returns a Permission with all Roles" do
      permission = permission_fixture()
      assert %Permission{id: permission_id, roles: roles} =
        Account.get_permission permission.id, :with_roles
      assert permission_id == permission.id
      assert is_list roles
    end
  end

  describe "Test get_permission_by/2:" do
    test "without option returns a Permission without Roles" do
      permission = permission_fixture()
      assert %Permission{id: permission_id, roles: roles} =
        Account.get_permission_by %{name: permission.name}
      assert permission_id == permission.id
      refute is_list roles
    end

    test "with :with_roles returns a Permission with all Roles" do
      permission = permission_fixture()
      assert %Permission{id: permission_id, roles: roles} =
        Account.get_permission_by %{name: permission.name}, :with_roles
      assert permission_id == permission.id
      assert is_list roles
    end
  end
end