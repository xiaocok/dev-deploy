docker run -d \
  --name elasticsearch \
  -v `pwd`/elasticsearch/config/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml \
  -p 9200:9200 \
  -p 9300:9300 \
  -e "discovery.type=single-node" \
  docker.elastic.co/elasticsearch/elasticsearch:7.12.1

# --restart=always \

# 插入数据
#curl -v -H 'Content-Type:application/json' -X POST -d '{"body": "there"}' 192.168.33.50:9200/index/_doc/1

# 查询数据
#curl -v -H 'Content-Type:application/json' -X GET 192.168.33.50:9200/index/_doc/1

# 修改数据
#curl -v -H 'Content-Type:application/json' -X PUT -d '{"body": "here"}' 192.168.33.50:9200/index/_doc/1

# 删除数据
#curl -v -H 'Content-Type:application/json' -X DELETE 192.168.33.50:9200/index/_doc/1
