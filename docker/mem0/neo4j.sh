docker run \
  --name neo4j \
  -p 7474:7474 -p 7687:7687 \
  --env NEO4J_AUTH=neo4j/mem0graph \
  neo4j:5.26.4


# --env NEO4J_AUTH=neo4j/mem0graph 账号密码
#  -v $HOME/neo4j/data:/data \
#  -v $HOME/neo4j/logs:/logs \
#  -v $HOME/neo4j/plugins:/plugins \
