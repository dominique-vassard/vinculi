defmodule VinculiDb.Account.Role do
  use Ecto.Schema
  import Ecto.Changeset

  alias VinculiDb.Coherence.User
  alias VinculiDb.Account.RolePermission
  alias VinculiDb.Account.Permission

  @required_fields ~w(name)

  schema "roles" do
    field :name, :string
    has_many :users, User
    many_to_many :permissions, Permission, join_through: RolePermission, on_replace: :delete

    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params,  @required_fields)
    |> validate_required(Enum.map @required_fields, &String.to_atom/1)
    |> validate_length(:name, min: 3, max: 40)
  end
end