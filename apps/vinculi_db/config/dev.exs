use Mix.Config

# Configure Vincuyli postgres database
config :vinculi_db, VinculiDb.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "vinculi",
  password: "Koysteuk",
  database: "vinculi_dev",
  hostname: "localhost",
  pool_size: 10