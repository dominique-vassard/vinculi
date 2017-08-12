use Mix.Config

%{host: hostname,
  userinfo: userinfo,
  path: database,
  port: port} = URI.parse(System.get_env("JAWSDB_URL"))
[username | [password]] = String.split(userinfo, ":")


# Ars Magica DB configuration
config :ars_magica, ArsMagica.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: username,
  password: password,
  hostname: hostname,
  database: String.slice(database, 1..-1)

# import_config "prod.secret.exs"