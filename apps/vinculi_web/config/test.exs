use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :vinculi_web, VinculiWeb.Endpoint,
  http: [port: 4001],
  server: false

# Environement information
config :vinculi_web, env: :test

# Basic auth configs
config :vinculi_web,
  username: "vinculi",
  password: "EjijsiquachFaHachquechoffAcErtya"
