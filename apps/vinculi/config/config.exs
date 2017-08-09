use Mix.Config

config :vinculi, ecto_repos: [Vinculi.Repo]

import_config "#{Mix.env}.exs"
