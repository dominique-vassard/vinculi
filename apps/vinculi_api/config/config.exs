# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :vinculi_api,
  namespace: VinculiApi,
  # ecto_repos: [VinculiApi.Repo]
  ecto_repos: []

# Configures the endpoint
config :vinculi_api, VinculiApi.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "4WXM4AvUlbU+GCeGXAg39k8ZWmXGjc7m8PFasct9OY5H6rLZWzHJPXFC6tfpn2Pw",
  render_errors: [view: VinculiApi.ErrorView, accepts: ~w(json)],
  pubsub: [name: VinculiApi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :vinculi_api, :generators,
  context_app: :vinculi_api

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
