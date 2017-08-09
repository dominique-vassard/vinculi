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

    Supervisor.start_link([
      supervisor(Vinculi.Repo, []),
    ], strategy: :one_for_one, name: Vinculi.Supervisor)
  end
end
