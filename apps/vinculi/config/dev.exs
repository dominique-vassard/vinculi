use Mix.Config

# Configure your database
config :vinculi, Vinculi.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "vinculi_dev",
  hostname: "localhost",
  pool_size: 10
