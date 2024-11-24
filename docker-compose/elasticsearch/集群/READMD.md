
# 部署说明

## 说明
节点 es01 监听的地址：localhost:9200

节点 es01 与节点 es02 的通信是基于docker的网络的服务名

节点 es01 与 es02 使用自己的挂载路径 esdata01、esdata02 


## 启动/停止
```shell
docker-compose up -d
```

退出，并删除挂载卷
```shell
docker-compose down -v
```

查看集群状态
```shell
curl http://127.0.0.1:9200/_cat/health
1472225929 15:38:49 docker-cluster green 2 2 4 2 0 0 0 0 - 100.0%
```

## 配置文件
容器内部配置文件路径
```shell
/usr/share/elasticsearch/config/
```

设置集群的节点名称，
docker run 增加-v 参数，挂载配置文件
```shell
-v full_path_to/custom_elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml
```

数据路径
```shell
/usr/share/elasticsearch/data
```

