use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :vinculi_web, VinculiWeb.Endpoint,
  env: :test,
  http: [port: 4001],
  server: false

# Basic auth configs
config :vinculi_web,
  username: "vinculi",
  password: "EjijsiquachFaHachquechoffAcErtya"
