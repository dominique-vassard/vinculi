defmodule VinculiApi.TestBasicAuth do
  use VinculiApi.ConnCase

  alias VinculiApi.BasicAuthPlug

  @username Application.get_env :vinculi_api, :username
  @password Application.get_env :vinculi_api, :password

  def use_basic_auth(conn, basic_auth \\ @username, password \\ @password) do
    header_content = "Basic " <> Base.encode64("#{basic_auth}:#{password}")
    conn
    |> put_req_header("authorization", header_content)
  end

  test "Access with rigt credentials should work", %{conn: n_conn} do
    conn = n_conn
    |> use_basic_auth()
    |> BasicAuthPlug.call([])
    refute conn.halted
  end

  test "Access with wrong basic_auth should not work", %{conn: n_conn} do
    conn = n_conn
    |> use_basic_auth("wrong")
    |> BasicAuthPlug.call([])
    assert conn.halted
  end

  test "Access with wrong password should not work", %{conn: n_conn} do
    conn = n_conn
    |> use_basic_auth(@username, "wrong")
    |> BasicAuthPlug.call([])
    assert conn.halted
  end
end