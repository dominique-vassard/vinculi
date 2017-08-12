use Mix.Config

# Configure  Neo4J database
config :bolt_sips, Bolt,
  url: System.get_env("GRAPHENEDB_BOLT_URL"),
  basic_auth: ["username": System.get_env("GRAPHENEDB_BOLT_USER"),
               "password": System.get_env("GRAPHENEDB_BOLT_PASSWORD")],
  ssl: true