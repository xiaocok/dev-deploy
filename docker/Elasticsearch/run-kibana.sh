docker run -d \
  --name kibana \
  -p 5601:5601 \
  --link elasticsearch:elasticsearch \
  -e "ELASTICSEARCH_HOSTS=http://elasticsearch:9200" \
  docker.elastic.co/kibana/kibana:7.12.1

# --restart=always \

#注意，需要先执行run-elasticsearch.sh，启动elasticsearch， 这里通过环境变量ELASTICSEARCH_HOSTS配置的地址

