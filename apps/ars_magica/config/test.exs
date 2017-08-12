use Mix.Config

# Ars Magica DB configuration
config :ars_magica, ArsMagica.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "arsmagbdd",
  password: "ars_magica",
  hostname: "localhost",
  database: "arsmagbdd_test"