defmodule VinculiWeb.TestHelpers do
  import Ecto.Changeset

  use Phoenix.ConnTest
  use ExUnit.CaseTemplate

  alias VinculiDb.TestSupport.RolePermissionFixtures
  alias VinculiDb.Coherence.User
  alias VinculiDb.Account
  alias VinculiDb.Repo

  @user_attrs %{first_name: "John", last_name: "Duff",
                email: "john.duff@email.com", password: "Str0ng!On3",
                password_confirmation: "Str0ng!On3"}

  @doc """
  Insert a automatically confirmed user into database.

  `attrs` will be merge in `@user_attrs` andused for insertion.
  """
  def insert_user(attrs \\ %{}) do
    u_attrs = Map.merge(@user_attrs, attrs)
    {role_name, user_attrs} = Map.pop(u_attrs, :role_name, "Administrator")


    RolePermissionFixtures.insert_fixtures()

    %User{}
    |> User.changeset(user_attrs)
    |> put_change(:confirmation_token, "")
    |> put_change(:confirmed_at, Ecto.DateTime.from_erl :calendar.local_time())
    |> put_change(:confirmation_sent_at, Ecto.DateTime.from_erl :calendar.local_time())
    |> put_change(:reset_password_token, "token123456")
    |> put_change(:reset_password_sent_at, Ecto.DateTime.from_erl :calendar.local_time())
    |> put_assoc(:role, Account.get_role_by(%{name: role_name}))
    |> Repo.insert!()
  end

  @doc """
  Allows to force a locale for testing purpose.

  Usage:
  ```elixir
  describe "My tests" do
    setup [:setup_locale]

    @tag locale: "fr"
    test ..... do
    end
  end
  ```
  """
  def setup_locale(%{locale: locale}) do
    Gettext.put_locale(VinculiWeb.Gettext, locale)
    :ok
  end
  def setup_locale(_context), do: :ok

  @doc """
  Allow to add a uere in database for testing purpose.
  User will be automatically confirmed and logged in.

  Usage:
  ```elixir
  describe "My tests" do
    setup [:setup_login]

    # for generic user
    @tag login true
    test ..... do
    end

    # For a specific user
    @tag login: %{email: "email@domain.com"}
    test ..... do
    end
  end
  ```

  """
  def setup_login(%{conn: conn, login: login}) do
    attrs = case login do
      true -> %{}
      _ -> login
    end
    user = insert_user(attrs)
    conn = assign conn, :current_user, user
    {:ok, conn: conn, user: user}
  end
  def setup_login(_context), do: :ok

  @doc """
    Check if given routes requires authentication
  """
  def check_authentication_required_routes(routes) do
    Enum.each(routes, fn conn -> assert html_response(conn, 302) end)
  end

  @doc """
    Check if given routes are public
  """
  def check_public_routes(routes) do
    Enum.each(routes, fn conn -> assert html_response(conn, 200) end)
  end
end