defmodule VinculiApi.BasicAuthPlug do
  @moduledoc """
    Plug for basic auth
    Check 'authorization' header for user:pass
  """
  import Plug.Conn

  @doc """
    Plug initialisation
  """
  def init(opts) do
    opts
  end

  @doc """
  Plug call
  """
  def call(conn, _opts) do
    case get_req_header conn, "authorization" do
      ["Basic " <> auth] -> check_creds(conn, auth)
      _ -> send_unauthorized_response(conn)
    end
  end

  @doc """
  Credentials check

  Valid user/password can be found in config under :basic_auth
  """
  def check_creds(conn, auth) do
    [username, password] = [Application.get_env(:basic_auth, :username),
                            Application.get_env(:basic_auth, :password)]
    case extract_creds(auth) do
      [^username, ^password] -> conn
      _ -> send_unauthorized_response(conn)
    end
  end

  defp extract_creds(auth) do
    auth
    |> Base.decode64!()
    |> String.split(":")
  end

   defp send_unauthorized_response(conn) do
    conn
    |> send_resp(:unauthorized, "401 Unauthorized")
    |> halt()
  end
end