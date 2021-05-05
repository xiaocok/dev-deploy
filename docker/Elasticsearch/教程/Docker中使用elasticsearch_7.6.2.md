
# Docker中使用elasticsearch:7.6.2

## 宿主机上创建文件
```shell
# 创建/mydata/elasticsearch/config/、/mydata/elasticsearch/data
mkdir -p /mydata/elasticsearch/{config,data}

# 允许外部访问
echo "http.host: 0.0.0.0" > /mydata/elasticsearch/config/elasticsearch.yml

# 添加权限，有数据会写入data目录
chmod -R 777 /mydata/elasticsearch/
```


## 启动elasticsearch
```shell
docker run -d \
  --restart=always \
  --name elasticsearch -p 9200:9200 -p 9300:9300 \
  -e  "discovery.type=single-node" \
  -e ES_JAVA_OPTS="-Xms64m -Xmx512m" \
  -v /mydata/elasticsearch/config/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml \
  -v /mydata/elasticsearch/data:/usr/share/elasticsearch/data \
  -v  /mydata/elasticsearch/plugins:/usr/share/elasticsearch/plugins \
  elasticsearch:7.6.2
```

## 启动kibana
```shell
docker run -d \
  --name kibana \
  -e ELASTICSEARCH_HOSTS=http://192.168.33.200:9200 \
  -p 5601:5601 \
  kibana:7.6.2
```

## 测试
* 查看elasticsearch版本信息
    ```shell
    # 访问自己虚拟机的9200端口，例如： http://192.168.33.200:9200/
    {
      "name" : "22799138e953",
      "cluster_name" : "elasticsearch",
      "cluster_uuid" : "x59rbg6aTzityKxaEIf1GA",
      "version" : {
        "number" : "7.6.2",
        "build_flavor" : "default",
        "build_type" : "docker",
        "build_hash" : "ef48eb35cf30adf4db14086e8aabd07ef6fb113f",
        "build_date" : "2020-03-26T06:34:37.794943Z",
        "build_snapshot" : false,
        "lucene_version" : "8.4.0",
        "minimum_wire_compatibility_version" : "6.8.0",
        "minimum_index_compatibility_version" : "6.0.0-beta1"
      },
      "tagline" : "You Know, for Search"
    }
    ```

* 通过Kibana客户端访问elasticsearch

    访问自己虚拟机的5601端口,在浏览器中打开Kibana客户端http://192.168.33.200:5601/app/kibana#/dev_tools/console



# 参考
* [Docker中使用elasticsearch:7.6.2](https://segmentfault.com/a/1190000037525333)

