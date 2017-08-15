# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :vinculi_web,
  namespace: VinculiWeb,
  ecto_repos: [VinculiDb.Repo]

# Configures the endpoint
config :vinculi_web, VinculiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "p9fFkq7EJDCRf+Dqobk7o4orzHrit2piwh1ZzHuy/RVGNIXZQNf1Sa1R/dkmc2mX",
  render_errors: [view: VinculiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: VinculiWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :vinculi_web, :generators,
  context_app: :vinculi

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# %% Coherence Configuration %%   Don't remove this line
config :coherence,
  user_schema: VinculiDb.Coherence.User,
  repo: VinculiDb.Repo,
  module: VinculiWeb,
  web_module: VinculiWeb,
  router: VinculiWeb.Router,
  messages_backend: VinculiDb.Coherence.Messages,
  logged_out_url: "/",
  email_from_name: "Vinculi",
  email_from_email: "dominique.vassard@gmail.com",
  opts: [:invitable, :confirmable, :authenticatable, :recoverable, :lockable,
         :trackable, :unlockable_with_token, :registerable]

config :coherence, VinculiWeb.Coherence.Mailer,
  adapter: Swoosh.Adapters.Mailgun,
  api_key: "key-781d9e526c394ab4d3d48df927bc4777",
  domain: "sandbox5109e75f640a4bf58ab0b735923ed4e7.mailgun.org"
# %% End Coherence Configuration %%
