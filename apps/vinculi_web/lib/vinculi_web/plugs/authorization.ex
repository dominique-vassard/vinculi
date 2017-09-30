defmodule VinculiWeb.AuthorizationPlug do
  @moduledoc """
    Plug tho authorize access to page based on user permissions

    Steps:
      - Retrieve controller / action from conn
      - Retrive user from conn
      - Retrieve required permissions from function
      - Check if user can access
      - If not, redirect to homepage with a flash

    To use this plug, add it to your controller.

    ## Example:
      plug VinculiWeb.AuthorizationPlug

    You can restrict its application to defined actions

    ## Example:
      plug VinculiWeb.AuthorizationPlug when action : [:index, :create]

    WARNING: An action without defined permissions is not accessible!
  """
  import Plug.Conn
  alias VinculiDb.Repo

  @doc """
    Plug init: nothing to be done
  """
  def init(opts) do
    opts
  end

  @doc """
    Plug call

    Steps:
      - Retrieve controller / action from conn
      - Retrive user from conn
      - Retrieve required permissions from function
      - Check if user can access
      - If not, redirect to homepage with a flash
  """
  def call(conn, _opts) do
    user = Coherence.current_user(conn)
    role = user.role |> Repo.preload(:permissions)

    required_perms = permissions_for(conn.private[:phoenix_controller],
                                     conn.private[:phoenix_action])

    case do_check_access(role, required_perms) do
      true -> conn
      _ -> handle_unauthorized conn
    end
  end

  defp do_check_access(role, [permission | tail_perms]) do
    case Enum.find role.permissions, fn (x) -> x.name == permission end do
      %VinculiDb.Account.Permission{} -> do_check_access(role, tail_perms)
      _ -> false
    end
  end
  defp do_check_access(_role, []), do: true

  @doc """
    Redirect to homepage and flash
  """
  def handle_unauthorized(conn) do
    conn
    |> Phoenix.Controller.put_flash(:error, "You can't access that page!")
    |> Phoenix.Controller.redirect(to: "/")
    |> halt
  end

  #######################################################################
  #    AUTHORIZATIONS
  #######################################################################

  # permissions_for signature:
  # permissions_for(controller_name, action_atom)

  @doc """
    Permissions for /restrict1
  """
  def permissions_for(Elixir.VinculiWeb.PageController, :restrict_one) do
    ["Read"]
  end

  @doc """
    Permissions for /restrict2
  """
  def permissions_for(Elixir.VinculiWeb.PageController, :restrict_two) do
    ["Write"]
  end

  @doc """
    Fallback permissions: Access denied!
  """
  def permissions_for(_, _) do
    ["NonExistingPerm"]
  end

end