# 为 Kubernetes 运行 etcd 集群

**官方文档地址：**

```shell
https://v1-19.docs.kubernetes.io/zh/docs/tasks/administer-cluster/configure-upgrade-etcd/
```



etcd 是兼具一致性和高可用性的键值数据库，可以作为保存 Kubernetes 所有集群数据的后台数据库。

您的 Kubernetes 集群的 etcd 数据库通常需要有个备份计划。



## 先决条件

- 运行的 etcd 集群个数成员为奇数。

- etcd 是一个 leader-based 分布式系统。确保主节点定期向所有从节点发送心跳，以保持集群稳定。

- 确保不发生资源不足。

  集群的性能和稳定性对网络和磁盘 IO 非常敏感。任何资源匮乏都会导致心跳超时，从而导致集群的不稳定。不稳定的情况表明没有选出任何主节点。在这种情况下，集群不能对其当前状态进行任何更改，这意味着不能调度新的 pod。

- 保持稳定的 etcd 集群对 Kubernetes 集群的稳定性至关重要。因此，请在专用机器或隔离环境上运行 etcd 集群，以满足[所需资源需求](https://github.com/coreos/etcd/blob/master/Documentation/op-guide/hardware.md#hardware-recommendations)。

- 在生产中运行的 etcd 的最低推荐版本是 `3.2.10+`。



## ETCD安装

### yum安装

```shell
# yum list etcd  --showduplicates|sort -r

etcd.x86_64                      3.3.11-2.el7.centos                      extras
etcd.x86_64                      3.2.32-1.el7_9                           extras
etcd.x86_64                      3.2.28-1.el7_8                           extras
```



### docker运行

- 创建持久化目录

  ```shell
  mkdir -p /usr/local/etcd/etcd-data
  ```

- 镜像地址 gcr.io/etcd-development/etcd 或者 quay.io/coreos/etcd

  ```shell
  docker pull quay.io/coreos/etcd:v3.5.0
  ```

- 运行命令

  ```shell
  docker run -d \
  -p 2379:2379 \
  -p 2380:2380 \
  --mount type=bind,source=/usr/local/etcd/etcd-data,destination=/etcd-data \
  --name etcd-v3.5.0 \
  quay.io/coreos/etcd:v3.5.0 \
  /usr/local/bin/etcd \
  --name s1 \
  --data-dir /etcd-data \
  --listen-client-urls http://0.0.0.0:2379 \
  --advertise-client-urls http://0.0.0.0:2379 \
  --listen-peer-urls http://0.0.0.0:2380 \
  --initial-advertise-peer-urls http://0.0.0.0:2380 \
  --initial-cluster s1=http://0.0.0.0:2380 \
  --initial-cluster-token tkn \
  --initial-cluster-state new \
  --log-level info \
  --logger zap \
  --log-outputs stderr
  ```

- 命令行

  ```shell
  docker exec etcd-v3.5.0 /bin/sh -c "/usr/local/bin/etcd --version"
  docker exec etcd-v3.5.0 /bin/sh -c "/usr/local/bin/etcdctl version"
  docker exec etcd-v3.5.0 /bin/sh -c "/usr/local/bin/etcdctl endpoint health"
  docker exec etcd-v3.5.0 /bin/sh -c "/usr/local/bin/etcdctl put foo bar"
  docker exec etcd-v3.5.0 /bin/sh -c "/usr/local/bin/etcdctl get foo"
  docker exec etcd-v3.5.0 /bin/sh -c "/usr/local/bin/etcdutl version"
  ```

  
