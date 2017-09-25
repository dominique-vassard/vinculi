defmodule VinculiDb.Account do
  @moduledoc """
  The accounts context
  """
  alias VinculiDb.Repo
  import Ecto.Query

  alias VinculiDb.Account.Role
  alias VinculiDb.Account.Permission

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking role changes.

  ## Examples

      iex> change_role()
      %Ecto.Changeset{source: %Role{}}

  """
  def change_role(%Role{} = role) do
    Role.changeset(role, %{})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking permission changes.

  ## Examples

      iex> change_permission()
      %Ecto.Changeset{source: %Permission{}}

  """
  def change_permission(%Permission{} = permission) do
    Permission.changeset(permission, %{})
  end

  def get_all_roles(options \\ :no_option)
  def get_all_roles(:with_permissions) do
    _get_all_roles()
    |> Repo.preload(:permissions)
  end

  def get_all_roles(_opts) do
    _get_all_roles()
  end

  defp _get_all_roles() do
    Repo.all from r in Role
  end

  def get_role(role_id, option \\ :no_option)
  @doc """
  Get role by id

  ## Examples

      iex> Account.get_role 1
      %VinculiDb.Account.Role{__meta__: #Ecto.Schema.Metadata<:loaded, "roles">,
      id: 1, inserted_at: ~N[2017-09-24 14:04:13.547052], name: "Administrator",
      permissions: #Ecto.Association.NotLoaded<association :permissions is not loaded>,
      updated_at: ~N[2017-09-24 14:04:13.555298]}
  """
  def get_role(role_id, :with_permissions) do
    do_get_role(role_id)
    |> Repo.preload(:permissions)
  end

  @doc """
  Get role by id

  ## Examples

      iex> Account.get_role 1, :with_permissions
      %VinculiDb.Account.Role{__meta__: #Ecto.Schema.Metadata<:loaded, "roles">,
      id: 1, inserted_at: ~N[2017-09-24 14:04:13.547052], name: "Administrator",
      permissions: [%VinculiDb.Account.Permission{__meta__: #Ecto.Schema.Metadata<:loaded, "permissions">,
      id: 1, inserted_at: ~N[2017-09-24 14:04:13.594391], name: "Administer",
      roles: #Ecto.Association.NotLoaded<association :roles is not loaded>,
      updated_at: ~N[2017-09-24 14:04:13.594398]},
      %VinculiDb.Account.Permission{__meta__: #Ecto.Schema.Metadata<:loaded, "permissions">,
      id: 2, inserted_at: ~N[2017-09-24 14:04:13.649142], name: "Read",
      roles: #Ecto.Association.NotLoaded<association :roles is not loaded>,
      updated_at: ~N[2017-09-24 14:04:13.649153]},
      %VinculiDb.Account.Permission{__meta__: #Ecto.Schema.Metadata<:loaded, "permissions">,
      id: 3, inserted_at: ~N[2017-09-24 14:04:13.675523], name: "Write",
      roles: #Ecto.Association.NotLoaded<association :roles is not loaded>,
      updated_at: ~N[2017-09-24 14:04:13.675530]},
      %VinculiDb.Account.Permission{__meta__: #Ecto.Schema.Metadata<:loaded, "permissions">,
      id: 4, inserted_at: ~N[2017-09-24 14:04:13.694790], name: "Validate",
      roles: #Ecto.Association.NotLoaded<association :roles is not loaded>,
      updated_at: ~N[2017-09-24 14:04:13.694800]}],
      updated_at: ~N[2017-09-24 14:04:13.555298]}
  """
  def get_role(role_id, _opt) do
    do_get_role(role_id)
  end

  defp do_get_role(role_id), do: Repo.get Role, role_id

  def get_role_by(attributes, option \\ :no_option)
  @doc """
  Get role by attributes with permissions preloaded.
  Attributes should be a map

  ## Examples

      iex> Account.get_role_by %{name: "Administrator"}
      %VinculiDb.Account.Role{__meta__: #Ecto.Schema.Metadata<:loaded, "roles">,
      id: 1, inserted_at: ~N[2017-09-24 14:04:13.547052], name: "Administrator",
      permissions: #Ecto.Association.NotLoaded<association :permissions is not loaded>,
      updated_at: ~N[2017-09-24 14:04:13.555298]}
  """
  def get_role_by(attributes, :with_permissions) do
    do_get_role_by(attributes)
    |> Repo.preload(:permissions)
  end

  @doc """
  Get role by attributes.
  Attributes should be a map

  ## Examples

      iex> Account.get_role_by %{name: "Administrator"}, :with_permissions
      %VinculiDb.Account.Role{__meta__: #Ecto.Schema.Metadata<:loaded, "roles">,
      id: 1, inserted_at: ~N[2017-09-24 14:04:13.547052], name: "Administrator",
      permissions: [%VinculiDb.Account.Permission{__meta__: #Ecto.Schema.Metadata<:loaded, "permissions">,
      id: 1, inserted_at: ~N[2017-09-24 14:04:13.594391], name: "Administer",
      roles: #Ecto.Association.NotLoaded<association :roles is not loaded>,
      updated_at: ~N[2017-09-24 14:04:13.594398]},
      %VinculiDb.Account.Permission{__meta__: #Ecto.Schema.Metadata<:loaded, "permissions">,
      id: 2, inserted_at: ~N[2017-09-24 14:04:13.649142], name: "Read",
      roles: #Ecto.Association.NotLoaded<association :roles is not loaded>,
      updated_at: ~N[2017-09-24 14:04:13.649153]},
      %VinculiDb.Account.Permission{__meta__: #Ecto.Schema.Metadata<:loaded, "permissions">,
      id: 3, inserted_at: ~N[2017-09-24 14:04:13.675523], name: "Write",
      roles: #Ecto.Association.NotLoaded<association :roles is not loaded>,
      updated_at: ~N[2017-09-24 14:04:13.675530]},
      %VinculiDb.Account.Permission{__meta__: #Ecto.Schema.Metadata<:loaded, "permissions">,
      id: 4, inserted_at: ~N[2017-09-24 14:04:13.694790], name: "Validate",
      roles: #Ecto.Association.NotLoaded<association :roles is not loaded>,
      updated_at: ~N[2017-09-24 14:04:13.694800]}],
      updated_at: ~N[2017-09-24 14:04:13.555298]}
  """
  def get_role_by(attributes, _opt) do
    do_get_role_by(attributes)
  end

  defp do_get_role_by(attributes), do: Repo.get_by Role, attributes

  def get_permission(permission_id, option \\ :no_option)
  @doc """
  Get permission by id

  ## Examples

      iex(22)> Account.get_permission 3
      %VinculiDb.Account.Permission{__meta__: #Ecto.Schema.Metadata<:loaded, "permissions">,
      id: 3, inserted_at: ~N[2017-09-24 14:04:13.675523], name: "Write",
      roles: #Ecto.Association.NotLoaded<association :roles is not loaded>,
      updated_at: ~N[2017-09-24 14:04:13.675530]}

  """
  def get_permission(permission_id, :with_roles) do
    do_get_permission(permission_id)
    |> Repo.preload(:roles)
  end

  @doc """
  Get permission by id

  ## Examples

      iex(23)> Account.get_permission 3, :with_roles
      %VinculiDb.Account.Permission{__meta__: #Ecto.Schema.Metadata<:loaded, "permissions">,
       id: 3, inserted_at: ~N[2017-09-24 14:04:13.675523], name: "Write",
       roles: [%VinculiDb.Account.Role{__meta__: #Ecto.Schema.Metadata<:loaded, "roles">,
         id: 1, inserted_at: ~N[2017-09-24 14:04:13.547052], name: "Administrator",
         permissions: #Ecto.Association.NotLoaded<association :permissions is not loaded>,
         updated_at: ~N[2017-09-24 14:04:13.555298]},
        %VinculiDb.Account.Role{__meta__: #Ecto.Schema.Metadata<:loaded, "roles">,
         id: 3, inserted_at: ~N[2017-09-24 14:04:13.739110], name: "Writer",
         permissions: #Ecto.Association.NotLoaded<association :permissions is not loaded>,
         updated_at: ~N[2017-09-24 14:04:13.739118]},
        %VinculiDb.Account.Role{__meta__: #Ecto.Schema.Metadata<:loaded, "roles">,
         id: 4, inserted_at: ~N[2017-09-24 14:04:13.775504], name: "Validator",
         permissions: #Ecto.Association.NotLoaded<association :permissions is not loaded>,
         updated_at: ~N[2017-09-24 14:04:13.775514]}],
       updated_at: ~N[2017-09-24 14:04:13.675530]}
  """
  def get_permission(permission_id, _opt) do
    do_get_permission(permission_id)
  end

  defp do_get_permission(permission_id), do: Repo.get Permission, permission_id

  def get_permission_by(attributes, option \\ :no_option)
  @doc """
  Get permission by id

  ## Examples

      iex(22)> Account.get_permission_by %{name: "Write"}
      %VinculiDb.Account.Permission{__meta__: #Ecto.Schema.Metadata<:loaded, "permissions">,
      id: 3, inserted_at: ~N[2017-09-24 14:04:13.675523], name: "Write",
      roles: #Ecto.Association.NotLoaded<association :roles is not loaded>,
      updated_at: ~N[2017-09-24 14:04:13.675530]}

  """
  def get_permission_by(attributes, :with_roles) do
    do_get_permission_by(attributes)
    |> Repo.preload(:roles)
  end

  @doc """
  Get permission by id

  ## Examples

      iex(23)> Account.get_permission_by %{name: "Write"}, :with_roles
      %VinculiDb.Account.Permission{__meta__: #Ecto.Schema.Metadata<:loaded, "permissions">,
       id: 3, inserted_at: ~N[2017-09-24 14:04:13.675523], name: "Write",
       roles: [%VinculiDb.Account.Role{__meta__: #Ecto.Schema.Metadata<:loaded, "roles">,
         id: 1, inserted_at: ~N[2017-09-24 14:04:13.547052], name: "Administrator",
         permissions: #Ecto.Association.NotLoaded<association :permissions is not loaded>,
         updated_at: ~N[2017-09-24 14:04:13.555298]},
        %VinculiDb.Account.Role{__meta__: #Ecto.Schema.Metadata<:loaded, "roles">,
         id: 3, inserted_at: ~N[2017-09-24 14:04:13.739110], name: "Writer",
         permissions: #Ecto.Association.NotLoaded<association :permissions is not loaded>,
         updated_at: ~N[2017-09-24 14:04:13.739118]},
        %VinculiDb.Account.Role{__meta__: #Ecto.Schema.Metadata<:loaded, "roles">,
         id: 4, inserted_at: ~N[2017-09-24 14:04:13.775504], name: "Validator",
         permissions: #Ecto.Association.NotLoaded<association :permissions is not loaded>,
         updated_at: ~N[2017-09-24 14:04:13.775514]}],
       updated_at: ~N[2017-09-24 14:04:13.675530]}
  """
  def get_permission_by(attributes, _opt) do
    do_get_permission_by(attributes)
  end

  defp do_get_permission_by(attributes), do: Repo.get_by Permission, attributes
end
