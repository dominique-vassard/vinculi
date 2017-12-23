# Script for dropping database.

# WARNING: Should not be used on large databases!

cql = "MATCH (n) DETACH DELETE n;"

neo4j_conn = Bolt.Sips.begin(Bolt.Sips.conn)
Bolt.Sips.query!(neo4j_conn, cql)
Bolt.Sips.commit(neo4j_conn)