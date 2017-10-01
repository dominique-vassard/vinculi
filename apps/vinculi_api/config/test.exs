use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :vinculi_api, VinculiApi.Endpoint,
  http: [port: 4001],
  server: false

config :basic_auth,
  username: "vinculi",
  password: "EjijsiquachFaHachquechoffAcErtya"
