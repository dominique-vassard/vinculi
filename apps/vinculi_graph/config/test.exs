use Mix.Config

# Print only warnings and errors during test
config :logger, level: :warn

# Configure  Neo4J database
config :bolt_sips, Bolt,
  hostname: "localhost",
  port: 7688,
  pool_size: 5,
  max_overflow: 1,
  basic_auth: ["username": "neo4j", "password": "Goreydyi"]