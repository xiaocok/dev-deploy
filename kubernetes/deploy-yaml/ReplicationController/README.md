## ReplicationController



### 什么是ReplicationController

ReplicationController确保Pod的副本数量始终是在可用的状态。如果Pod过多时将删除多余的数量，较少时则创建新的Pod。



### ReplicationController操作

**通过yaml资源定义清单创建**

```shell
$ kubectl apply -f rc-demo.yaml
```

```yaml
apiVersion: v1
kind:ReplicationController
metadata:
  name: nginx
spec:
  replicas: 3 		# 副本数量，通过此字段来伸缩Pod的数量
  selector: 		# 标签选择器，匹配相同的Pod标签进行管理Pod
    app: nginx
  template: 		# Pod模板
    metadata:
      name: nginx
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.16
```

**检查ReplicationController的状态**

```shell
$ kubectl describe rc/nginx
```

**删除ReplicationController**

```shell
$ kubectl delete -f rc-demo.yaml
$ kubectl delete rc nginx
```



### 使用技巧

目前官方已不建议使用ReplicationController，建议使用ReplicaSet来代替ReplicationController的使用，两者主要区别在于选择器的支持，ReplicationController只能支持等式的选择，而ReplicaSet可以支持声明式集的选择等。



### 参考

- [Kubernetes - 4.2 Workload - ReplicationController](https://www.toutiao.com/i6799990384911974916/?group_id=6799990384911974916)

