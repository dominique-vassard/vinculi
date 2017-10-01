defmodule VinculiApi.TestMetaController do
  use VinculiApi.ConnCase

  test "labels/2", %{conn: conn} do
    # n_conn = get conn, meta_path(conn, :labels)
    n_conn = conn
    |> use_basic_auth("vinculi", "EjijsiquachFaHachquechoffAcErtya")
    |> get(meta_path(conn, :labels))
    content = json_response n_conn, 200
    IO.puts inspect content
  end

  def use_basic_auth(conn, username, password) do
    header_content = "Basic " <> Base.encode64("#{username}:#{password}")
    conn
    |> put_req_header("authorization", header_content)
  end
end