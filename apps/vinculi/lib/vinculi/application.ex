defmodule Vinculi.Application do
  @moduledoc """
  The Vinculi Application Service.

  The vinculi system business domain lives in this application.

  Exposes API to clients such as the `VinculiWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    port = (System.get_env("PORT") || "3333") |> String.to_integer

    cowboy = Plug.Adapters.Cowboy.child_spec(:http, Vinculi.Proxy, [], [port: port])

    children = [
      cowboy
    ]

    opts = [strategy: :one_for_one, name: Vinculi.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
