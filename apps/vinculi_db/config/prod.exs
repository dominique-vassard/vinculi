use Mix.Config

# Do not print debug messages in production
config :logger, level: :info

# Configure Vinculi postgres database
config :vinculi_db, VinculiDb.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true
