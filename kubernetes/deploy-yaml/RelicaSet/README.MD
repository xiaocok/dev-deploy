

# RelicaSet



### 什么是RelicaSet？

ReplicaSet是为了保持维护的期待Pod副本数量与现时Pod副本数量一致。如在由于Pod异常退出导致期待的副本数量不足时，会自动创建新的Pod保证到与期望的Pod副本数量一致。



### ReplicaSet的工作流程

定义副本数量，定义一个选择器，指定选择器如何获取到具有特定标识Pod，定义一个模板指定新创建的Pod的期望状态。



Kubernetes官方强烈建议避免直接使用ReplicaSet，而应该通过Deployment来创建RS和Pod。

由于ReplicaSet是ReplicationController的代替物，ReplicaSet是新一代的ReplicationController。



因此ReplicationController和ReplicaSet的用法基本相同，但ReplicaSet的pod标签选择器的表达能力更强，ReplicaSet支持集合式的selector。

ReplicationController 的标签选择器只允许包含某个标签的匹配 pod, 但ReplicaSet 的选择器还允许匹配缺少某个标签的 pod, 或包含特定标签名的 pod, 不管其值如何。



例如：

ReplicationController只能匹配nv=dev或env=pro的标签，ReplicaSet能同时匹配两种标签，env=dev和env=pro。

ReplicaSet 可匹配所有包含名为 env 的标签的 pod, 无论ReplicaSet 的实际值是什么（可以理解为 env= *)。



kubectl apply -f rs-demo.yaml

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  replicas: 3 		#副本数量
  selector: 		#标签选择器
    matchLabels:
      app: nginx
  template: 		#Pod的模板
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.16
```

### 使用技巧

官方不建议单独使用ReplicaSet，建议使用Deployment来代替ReplicaSet的单独使用，通过Deployment来创建ReplicaSet，Deployment比ReplicaSet多了例如支持版本回滚等新功能特性。

