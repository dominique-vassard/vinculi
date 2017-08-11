# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :vinculi_db,
  namespace: VinculiDb,
  ecto_repos: [VinculiDb.Repo]


# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure for your application as:
#
#     config :vinculi_db, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:vinculi_db, :key)
#
# Or configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
import_config "#{Mix.env}.exs"

# %% Coherence Configuration %%   Don't remove this line
config :coherence,
  user_schema: VinculiDb.Coherence.User,
  repo: VinculiDb.Repo,
  module: VinculiDb,
  web_module: VinculiDbWeb,
  router: VinculiDbWeb.Router,
  messages_backend: VinculiDbWeb.Coherence.Messages,
  logged_out_url: "/",
  email_from_name: "Your Name",
  email_from_email: "yourname@example.com",
  opts: [:invitable, :confirmable, :authenticatable, :recoverable, :lockable,
         :trackable, :unlockable_with_token, :registerable]

# config :coherence, VinculiDbWeb.Coherence.Mailer,
#   adapter: Swoosh.Adapters.Sendgrid,
#   api_key: "your api key here"
# %% End Coherence Configuration %%
