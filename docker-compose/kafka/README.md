## 【Kafka系列】Kafka安装与部署

https://zhuanlan.zhihu.com/p/668317839

https://blog.csdn.net/Zz1366/article/details/130756777

https://github.com/IBM/sarama

https://github.com/segmentio/kafka-go



| 文件                           | 说明                     |
| ------------------------------ | ------------------------ |
| docker-compose-multi-node.yml  | 3节点集群                |
| docker-compose-single-node.yml | 单节点                   |
| kafka-go.yml                   | 单节点：用户名、密码登录 |
| docker-compose-error.yml       | 多节点，联网异常         |



### kafka参数

```shell
docker run -d --name kafka -p 9193:9092 -v /home/docker/kafka/config:/etc/kafka \
-e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://xxx.25.208.118:9193 \
-e KAFKA_LISTENERS=PLAINTEXT://0.0.0.0:9092 \
-e KAFKA_ADVERTISED_HOST_NAME=xxx.25.208.118 \
-e KAFKA_ZOOKEEPER_CONNECT=xxx.25.208.118:2181 \
wurstmeister/kafka
```

上述命令做了以下几件事：

- -d: 这是Docker命令的选项，表示在后台运行容器。
- --name kafka: 这个选项为容器指定一个名字，即容器的名称为 "kafka"。
- -p 9193:9092: 这个选项用于将容器端口映射到主机端口。容器内部的Kafka端口9092被映射到主机上的端口9193，主要是为了防止端口扫描。
- -v /home/docker/kafka/config:/etc/kafka: 这个选项用于将主机文件系统上的Kafka配置目录/home/docker/kafka/config挂载到容器内部的/etc/kafka目录。这样你可以将自定义的Kafka配置文件放在主机上，并通过挂载使其在容器内生效。
- --network host: 这个选项将容器连接到主机的网络命名空间，这允许容器与主机共享网络设置，以便容器可以使用主机的网络接口。
- -e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://xxx.215.208.118:9193: 这个选项通过环境变量KAFKA_ADVERTISED_LISTENERS设置了Kafka的广告监听器。它告诉Kafka容器要公开的监听地址和端口。在这里，Kafka容器会在地址xxx.215.208.118的端口9193上公开。
- -e KAFKA_LISTENERS=PLAINTEXT://0.0.0.0:9092: 这个选项通过环境变量KAFKA_LISTENERS设置了Kafka的监听器。它允许Kafka容器接受来自任何主机的连接，0.0.0.0表示所有可用的网络接口。
- -e KAFKA_ADVERTISED_HOST_NAME=xxx.215.208.118: 这个选项通过环境变量KAFKA_ADVERTISED_HOST_NAME设置了Kafka的广告主机名。这是广告给客户端的Kafka主机名。
- -e KAFKA_ZOOKEEPER_CONNECT=xxx.215.208.118:2181: 这个选项通过环境变量KAFKA_ZOOKEEPER_CONNECT设置了Kafka的ZooKeeper连接地址，以便Kafka能够与ZooKeeper协调器进行通信。



### kafka集群

```yaml
version: '3.5'
services:
  zookeeper:
    image: wurstmeister/zookeeper
    container_name: zookeeper
    ports:
      - "2181:2181"
  kafka1:
    image: wurstmeister/kafka
    container_name: kafka1
    volumes:
        - /var/run/docker.sock:/var/run/docker.sock
    ports:
      - "9092:9092"
    environment:
      KAFKA_ADVERTISED_HOST_NAME: 42.193.22.180         ## 广播主机名称，一般用IP指定
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
      KAFKA_ADVERTISED_PORT: 9092
      KAFKA_LOG_RETENTION_HOURS: 120
      KAFKA_MESSAGE_MAX_BYTES: 10000000
      KAFKA_REPLICA_FETCH_MAX_BYTES: 10000000
      KAFKA_GROUP_MAX_SESSION_TIMEOUT_MS: 60000
      KAFKA_NUM_PARTITIONS: 3
      KAFKA_DELETE_RETENTION_MS: 1000
      KAFKA_LISTENERS: PLAINTEXT://:9092
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://42.193.22.180:9092
      KAFKA_BROKER_ID: 1
  kafka2:
    image: wurstmeister/kafka
    container_name: kafka2
    volumes:
        - /var/run/docker.sock:/var/run/docker.sock
    ports:
      - "9093:9092"
    environment:
      KAFKA_ADVERTISED_HOST_NAME: 42.193.22.180         ## 广播主机名称，一般用IP指定
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
      KAFKA_ADVERTISED_PORT: 9093
      KAFKA_LOG_RETENTION_HOURS: 120
      KAFKA_MESSAGE_MAX_BYTES: 10000000
      KAFKA_REPLICA_FETCH_MAX_BYTES: 10000000
      KAFKA_GROUP_MAX_SESSION_TIMEOUT_MS: 60000
      KAFKA_NUM_PARTITIONS: 3
      KAFKA_DELETE_RETENTION_MS: 1000
      KAFKA_LISTENERS: PLAINTEXT://:9093
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://42.193.22.180:9093
      KAFKA_BROKER_ID: 2
  kafka3:
    image: wurstmeister/kafka
    container_name: kafka3
    volumes:
        - /var/run/docker.sock:/var/run/docker.sock
    ports:
      - "9094:9092"
    environment:
      KAFKA_ADVERTISED_HOST_NAME: 42.193.22.180         ## 广播主机名称，一般用IP指定
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
      KAFKA_ADVERTISED_PORT: 9094
      KAFKA_LOG_RETENTION_HOURS: 120
      KAFKA_MESSAGE_MAX_BYTES: 10000000
      KAFKA_REPLICA_FETCH_MAX_BYTES: 10000000
      KAFKA_GROUP_MAX_SESSION_TIMEOUT_MS: 60000
      KAFKA_NUM_PARTITIONS: 3
      KAFKA_DELETE_RETENTION_MS: 1000
      KAFKA_LISTENERS: PLAINTEXT://:9094
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://42.193.22.180:9094
      KAFKA_BROKER_ID: 3

  kafka-manager:
    image: sheepkiller/kafka-manager
    container_name: kafka-manager
    environment:
        ZK_HOSTS: 42.193.22.180                         ## 修改:宿主机IP
    ports:
      - "9009:9000"
```



### kafka单节点

```yaml
version: '3.5'
services:
  zookeeper:
    image: wurstmeister/zookeeper
    container_name: zookeeper
    ports:
      - "2181:2181"
  kafka:
    image: wurstmeister/kafka
    container_name: kafka
    volumes:
        - /var/run/docker.sock:/var/run/docker.sock
    ports:
      - "9092:9092"
    environment:
      KAFKA_ADVERTISED_HOST_NAME: 42.193.22.180         ## 广播主机名称，一般用IP指定
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
      KAFKA_ADVERTISED_PORT: 9092
      KAFKA_LOG_RETENTION_HOURS: 120
      KAFKA_MESSAGE_MAX_BYTES: 10000000
      KAFKA_REPLICA_FETCH_MAX_BYTES: 10000000
      KAFKA_GROUP_MAX_SESSION_TIMEOUT_MS: 60000
      KAFKA_NUM_PARTITIONS: 3
      KAFKA_DELETE_RETENTION_MS: 1000
      KAFKA_LISTENERS: PLAINTEXT://:9092
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://42.193.22.180:9092
      KAFKA_BROKER_ID: 1
  kafka-manager:
    image: sheepkiller/kafka-manager
    container_name: kafka-manager
    environment:
        ZK_HOSTS: 42.193.22.180                         ## 修改:宿主机IP
    ports:
      - "9009:9000"
```



### 运行命令

```shell
# 3节点集群
docker-compose up -d

# 单节点
docker-compose -f docker-compose-single-node.yml up -d
```







### 脚本位置

/opt/kafka/bin

/opt/kafka_2.13-2.8.1/bin

```shell
root@e6b95a6aeeda:/opt/kafka/bin# pwd
/opt/kafka/bin
root@e6b95a6aeeda:/opt/kafka/bin# ls
connect-distributed.sh        kafka-preferred-replica-election.sh
connect-mirror-maker.sh       kafka-producer-perf-test.sh
connect-standalone.sh         kafka-reassign-partitions.sh
kafka-acls.sh                 kafka-replica-verification.sh
kafka-broker-api-versions.sh  kafka-run-class.sh
kafka-cluster.sh              kafka-server-start.sh
kafka-configs.sh              kafka-server-stop.sh
kafka-console-consumer.sh     kafka-storage.sh
kafka-console-producer.sh     kafka-streams-application-reset.sh
kafka-consumer-groups.sh      kafka-topics.sh
kafka-consumer-perf-test.sh   kafka-verifiable-consumer.sh
kafka-delegation-tokens.sh    kafka-verifiable-producer.sh
kafka-delete-records.sh       trogdor.sh
kafka-dump-log.sh             windows
kafka-features.sh             zookeeper-security-migration.sh
kafka-leader-election.sh      zookeeper-server-start.sh
kafka-log-dirs.sh             zookeeper-server-stop.sh
kafka-metadata-shell.sh       zookeeper-shell.sh
kafka-mirror-maker.sh
root@e6b95a6aeeda:/opt/kafka/bin#


root@e6b95a6aeeda:/opt/kafka_2.13-2.8.1/bin# pwd
/opt/kafka_2.13-2.8.1/bin
root@e6b95a6aeeda:/opt/kafka_2.13-2.8.1/bin#
root@e6b95a6aeeda:/opt/kafka_2.13-2.8.1/bin#
root@e6b95a6aeeda:/opt/kafka_2.13-2.8.1/bin# ls
connect-distributed.sh        kafka-preferred-replica-election.sh
connect-mirror-maker.sh       kafka-producer-perf-test.sh
connect-standalone.sh         kafka-reassign-partitions.sh
kafka-acls.sh                 kafka-replica-verification.sh
kafka-broker-api-versions.sh  kafka-run-class.sh
kafka-cluster.sh              kafka-server-start.sh
kafka-configs.sh              kafka-server-stop.sh
kafka-console-consumer.sh     kafka-storage.sh
kafka-console-producer.sh     kafka-streams-application-reset.sh
kafka-consumer-groups.sh      kafka-topics.sh
kafka-consumer-perf-test.sh   kafka-verifiable-consumer.sh
kafka-delegation-tokens.sh    kafka-verifiable-producer.sh
kafka-delete-records.sh       trogdor.sh
kafka-dump-log.sh             windows
kafka-features.sh             zookeeper-security-migration.sh
kafka-leader-election.sh      zookeeper-server-start.sh
kafka-log-dirs.sh             zookeeper-server-stop.sh
kafka-metadata-shell.sh       zookeeper-shell.sh
kafka-mirror-maker.sh
root@e6b95a6aeeda:/opt/kafka_2.13-2.8.1/bin#
```

