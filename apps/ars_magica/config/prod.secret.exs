use Mix.Config

# Ars Magica DB configuration
config :ars_magica, ArsMagica.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: System.get_env("ARS_MAGICA_DB_USER"),
  password: System.get_env("ARS_MAGICA_DB_PASSWORD"),
  hostname: System.get_env("ARS_MAGICA_DB_HOST"),
  database: "arsmagbdd"