defmodule Vinculi.Proxy do
  def init(options) do
    options
  end

  def call(conn, _opts) do
    cond do
      conn.request_path =~ ~r{/api} ->
        VinculiApiWeb.Endpoint.call(conn, [])
      true ->
        VinculiWeb.Endpoint.call(conn, [])
    end
  end
end