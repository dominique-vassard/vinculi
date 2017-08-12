use Mix.Config

# Configure  Neo4J database
config :bolt_sips, Bolt,
  hostname: "localhost",
  port: 7687,
  pool_size: 5,
  max_overflow: 1,
  basic_auth: ["username": "neo4j", "password": "Goreydyi"]