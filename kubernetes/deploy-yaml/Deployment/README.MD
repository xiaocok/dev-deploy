##　Deployment



[TOC]

### 什么是Deployment

Deployment提供了运行Pod能力，并且为Pod提供滚动升级、伸缩、副本等功能，一般用于运行无状态的应用。目前建议使用Deployment来代替RelicaSet及ReplicationController的使用。



### 创建Deployment

#### 通过命令

```shell
kubectl create deployment nginx-deployment --image=nginx:1.16
```

#### 通过yaml

```yaml
# kubectl apply -f nginx-deployment.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.16
```

#### 查看Deployment列表

```shell
kubectl get deployment
```

#### 查看Deployment描述信息

```shell
kubectl describe deployment
```



### Deployment 手动伸缩Pod数量

#### 方式1：通过命令kubectl set image

```shell
kubectl scale deployment nginx-deployment --replicas 5
```

#### 方式2：通过kubectl apply

```yaml
# kubectl apply -f nginx-deployment.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 5
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.16
```

#### 方式3：通过kubectl edit

```yaml
# kubectl edit deployment/nginx-deployment

spec:
  replicas: 5
```



### Deployment 自动伸缩Pod数量 (Horizontal Pod Autoscaler)

HPA基于观察到的CPU利用率或借助自定义指标自动缩放 ReplicaSet、Deployment中的Pod数量 。控制器会定期调整复制控制器或部署中副本的数量，以使观察到的平均CPU利用率与用户指定的目标相匹配。

#### 方式1：通过命令autoscale

```shell
kubectl autoscale deployment nginx-deployment --min=5 --max=10 --cpu-percent=80
```

#### 方式2：通过yaml文件

```yaml
# kubectl apply -f hpa-demo.yaml

apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
  name:  nginx-deployment
spec:
  scaleTargetRef:
    apiVersion: apps/v1beta1
    kind: Deployment
    name: nginx-deployment
  minReplicas: 5
  maxReplicas: 10
  targetCPUUtilizationPercentage: 80
```

#### 方式3：通过kubectl edit

```yaml
# kubectl edit hpa nginx-deployment

spec:
  maxReplicas: 10
  minReplicas: 5
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: nginx-deployment
  targetCPUUtilizationPercentage: 80
```

#### 查看HPA列表

```shell
kubectl get hpa
```

#### 查看HPA描述信息

```shell
kubectl describe hpa nginx-deployment
```



### Deployment 版本管理

通过更改部署的Pod模板规范来更新Deployment中Pod镜像。触发更新时Deployment会停止Pod及逐渐将Pod的数量缩减为零，然后使用Pod模板来调出新的Pod。

#### 方式1：通过kubectl set image

```shell
kubectl set image deployment/nginx-deployment nginx=nginx:1.17
```

#### 方式2：通过yaml文件

```yaml
# kubectl apply -f deployment-demo.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 5
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.17
```

#### 方式3：通过kubectl edit

```yaml
# kubectl edit deployment/nginx-deployment

spec:
  containers:
    image: nginx:1.17
```



#### 通过.spec.revisionHistoryLimit 字段

可指定为该 Deployment 保留多少个旧的 ReplicaSet。默认为10，当为0时，将无法对Deployment进行回滚操作。



#### 查看历史版本

```shell
kubectl rollout history deployment/nginx-deploymen
```

在这里 **版本1的是nginx:1.16，版本2是nginx:1.17**



#### 回滚版本到版本1

```shell
kubectl rollout undo deployment/nginx-deployment
```



#### 查看更新状态

```shell
kubectl rollout status deployment/nginx-deployment
```



#### 暂停更新

```shell
kubectl rollout pause deployment/nginx-deployment
```



#### 恢复更新

```shell
kubectl rollout resume deployment/nginx-deployment
```



### 部署策略

#### Recreate: (重建) 

停止旧版本服务后部署新版本优点: 容易配置，服务一次性更新。缺点: 部署时间长，取决于旧版本的停止时间及新版本的部署时间。

通过Deployment YAML配置清单定义

```yaml
spec:
  replicas: 3
  strategy:
    type: Recreate
```

#### RollingUpdate: (滚动)

旧版本到新版本的逐步替换的策略优点: 容易配置，不用停机，处理状态平衡的服务方便。缺点: 需要一定的时间去完成部署、回滚，无法控制流量。

通过Deployment YAML配置清单定义

```yaml
spec:
  strategy: 
    type: RollingUpdate 	#指定滚动更新
    rollingUpdate: 
      maxSurge: 25% 		#超过期望的Pod数量
      maxUnavailable: 25% 	#不可用Pod最大数量
```

```shell
# 设置升级前等待时间，防止容器启动后造成无法提供服务
.spec.strategy.rollingUpdate.minReadySeconds:

# 设置升级过程中最多可以比定义的Pod多出的数量
.spec.strategy.rollingUpdate.maxSurge:

# 设置升级过程中最多有多少个Pod处于不可用状态
.spec.strategy.rollingUpdate.maxUnavaible:
```

定义滚动升级的策略，如果maxUnavaible用默认值1，实际没起到升级失败后对旧Pod的保护。如果新的Pod启动失败，依然把旧的正常Pod Kill掉了，这不符合我们的预期。改成百分比后，若新Pod启动失败，则升级过程会被Block住，旧的正常Pod还是处于Running状态。

#### Blue/Green: (蓝绿) 

保持旧版本，发布新版本，然后将流量从旧版本切换到新版本优点: 即时部署、回滚，服务一次性更新。缺点: 由于新旧版本同时存在需要2倍的资源，无法处理有状态应用。

通过Service YAML配置清单定义

```yaml
 labels:
   app: nginx
   version: v1.0.0

 labels:
   app: nginx
   version: v2.0.0
```

#### Canary: (金丝雀)

切换一部分用户到新版本，然后在将全部流量切换到新版本优点: 快速回滚，如果出问题情况下影响最小缺点: 需要一定的时间去完成部署、回滚

通过Deployment YAML配置清单定义，调整不同ReplicaSet的副本数

```yaml
spec: # Version v1.0.0
  replicas: 90

spec: # Version v2.0.0
  replicas: 10
```

者可以通过Istio Route YAML配置清单定义

```yaml
route:
- tags:
  version: v1.0.0
  weight: 90
- tags:
  version: v2.0.0
  weight: 10
```

#### A/B testing: (A/B测试) 

根据不同的条件将流量切换到新版本，例如Cookie、地址位置、语言等优点: 多版本同时运行，可控制流量缺点: 需要负载均衡器根据条件去调度流量，需要分布式跟踪去解决会话错误问题

通过Istio Route YAML配置清单定义

```yaml
kind: RouteRule 
metadata: 
    name: nginx-v1.0.0
    spec: 
        destination: 
            name: nginx
        route: 
        - labels: 
            version: v1.0.0 
        match: 
            request: 
                headers: 
                    x-api-version: 
                        exact: "v1.0.0"

kind: RouteRule 
metadata: 
    name: nginx-v2.0.0
    spec: 
        destination: 
            name: nginx
        route: 
        - labels: 
            version: v2.0.0 
        match: 
            request: 
                headers: 
                    x-api-version: 
                        exact: "v2.0.0"
```

#### Shadow: (影子)

传入旧版本的请求流量镜像到新版本，响应流量将会被丢弃，当满足稳定性的测试时将会切换流量至新版本。

优点: 可以使用生产的流量对新版本进行测试而对用户没有影响

缺点: 由于新旧版本同时存在需要2倍的资源，配置复杂，可能需要模拟服务提供消相应

**通过Istio VirtualSerivce YAML配置清单定义**

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: nginx-vs
  labels:
    app: nginx
spec:
  hosts:
    - nginx.local
  gateways:
    - nginx
  http:
    - route:
        - destination:
            host: nginx-v1.0.0
      mirror:
        host: nginx-v2.0.0
```

> 一般在充足的测试下通常使用滚动或者蓝绿方案，蓝绿及阴影的方案对资源要求。
>
> 如果缺乏测试或者信心可以使用金丝雀、A/B测试、影子方案。
>
> 如果测试特定的维度可以使用A/B测试方案。
>
> 如果使用到影子方案则需要额外的服务模拟流量，以及防止对数据的重复生产，但用在测试性能时很有用。



### Deployment状态管理

与Pod一样，Deployment的声明周期不是一直处于同一个状态不变的，在操作ReplicaSet时状态会随之改变。



Deployment的状态，Conditions段

- Progressing：Deployment正在创建新的ReplicaSet，正在扩容、缩容已有的ReplicaSet。

- Available：Deployment的可用副本数已经达到期望定义的策略，ReplicaSet中的版本已经更新完成。
- Failed：Deployment配置了无效的引用、错误的探针、无法拉取镜像、权限不足等。

```text
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Progressing    True    NewReplicaSetAvailable
  Available      True    MinimumReplicasAvailable
```



通过kubectl查看Deployment状态情况，Conditions段

```shell
kubectl describe deployment
kubectl get deployment -o yaml
```



### 使用技巧

在业务情况允许下，尽量将容器设置成无状态化的方式运行，这样对于环境等要求是最小的。而且容器设置采用最小化功能的原则，一个Pod内可以包含多个容器负责不同的功能。



#### 参考

- [Kubernetes - 4.4 Workload - Deployment](https://www.toutiao.com/i6799991046408241678/?group_id=6799991046408241678)

