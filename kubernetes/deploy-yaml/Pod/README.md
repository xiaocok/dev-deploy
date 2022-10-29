## Pod

### 什么是Pod?

Kubernetes中最小的管理单元，作为应用运行的载体。当Pod运行多个容器时，同一个Pod中的所有容器可以共享PID、Network、IPC、UTS命名空间。 打个比方，例如Pod是豆荚，Container容器就是豆子，一个豆荚里可以有一个或者多个豆子。



### Pod的使用方式

**通过kubectl创建**

```shell
$ kubectl run nginx-pod --image=nginx:1.16
```



**通过yaml资源定义清单创建**

```shell
$ kubectl apply -f nginx-pod.yaml
```



### yaml说明

```yaml
apiVersion: v1 			#表示api资源是哪一个组及版本
kind: Pod 				#表示资源类别
metadata: 				#表示元数据
  name: nginx 			#名称，作用域在名称空间内唯一
spec: 					#表示期望状态
  containers: 			#表示容器资源
  - name: nginx 		#名称，作用域在Pod内唯一
    image: nginx:1.16 	#指定镜像
```



### Pod的资源管理

默认情况下不指定资源限制时，Pod对CPU和内存的使用是没有上限的。

kubectl apply -f pod-resouce-management.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx:1.16
    resources:
      requests: 		#所需资源
        memory: "64Mi"
        cpu: "250m"
      limits: 			#资源限制
        memory: "128Mi"
        cpu: "500m"
```



### Pod QoS 服务质量

在Kubernetes中，Pod的QoS服务质量有3个级别，通过资源的指定赋予不同的QoS标签，在节点出现资源不足时根据Pod QoS级别就会采用顺序驱逐。

- BestEffortPod中的容器都没有设置CPU或内存的Requests及Limits，QoS优先级最低，节点资源不足时将被优先驱逐。
- BurstablePod中的至少有一个容器设置CPU或内存的Requests及Limits，且Requests不等于Limits。QoS优先级中等。
- GuaranteedPod中的全部容器都设置CPU或内存的Requests及Limits，且Requests等于Limits。QoS优先级最高。



kubectl apply -f pod-qos-besteffort.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-qos-besteffort
spec:
  containers:
  - name: nginx
    image: nginx:1.16
    resources: 			# 不指定
```



kubectl apply -f pod-qos-burstable.yaml

```shell
apiVersion: v1
kind: Pod
metadata:
  name: nginx-qos-burstable
spec:
  containers:
  - name: nginx
    image: nginx:1.16
    resources: 			# 指定内存资源，但不指定CPU资源，且所需资源及资源限制不同
      requests: 
        memory: "64Mi"
```



kubectl apply -f pod-qos-guaranteed.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-qos-guaranteed
spec:
  containers:
  - name: nginx
    image: nginx:1.16
    resources: 			# 指定相同数值的所需内存资源及内存资源限制
      requests:  
        memory: "64Mi"
        cpu: "250m"
      limits: 
        memory: "64Mi"
        cpu: "250m"
```



### Pod的生命周期

Pod的本身的设计理念就是一部状态机，生命周期不是一直处于一个状态的，由用户手动操作或者控制器操作后将会改变其状态。在Pod中的status.phase字段记录着目前pod的生命周期阶段，在Pod中一共有5种运行状态：

- Pending: 集群已接收Pod创建指令并完成Pod创建，但Pod未被绑定到节点或容器未完成运行。

- Running: Pod已绑定到节点，容器已全部创建完成，并且最少有一个容器在运行。

- Succeeded: Pod中的容器已终止运行且不会启动。

- Failed: Pod中的容器由故障导致终止运行。

- Unknown: 无法确定Pod的状态。



### Pod的重启策略

当Pod中的容器处于退出状态时，kubelet就根据资源定义清单spec.restartPolicy的重启策略进行对应操作。

- Always: 默认的重启策略，如果容器处于退出状态时则重启。
- OnFailure: 当容器退出状态不为0则重启。
- Never: 从不重启。

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  restartPolicy: Always #重启策略
  containers:
  - name: nginx
    image: nginx:1.16
```



### Pod的容器探针

容器探针是由各个节点kubelet对容器的健康情况的诊断方法。应用于保证业务可用性，通过检查到故障后下线服务避免影响业务，以及重启服务进行自动恢复。

容器探针

- livenessProbe: 存活探针解决针对容器在运行一段时间后出现异常情况而需要重启解决的问题。在探针检测失败后，容器会被杀掉，并根据重启策略进行重启。

- readinessProbe: 就绪探针解决容器由于依赖其他服务等情况无法一启动就开始被调度。在探针检测失败后，将会service endpoint下线掉该Pod，在恢复后会重新加入service endpoint提供服务。
- startupProbe: 启动探针 - v1.16引入新功能针对在启动时间较长的容器，避免存活探针检测时对容器的启动时间约束。

探测方式

- ExecAction 通过对容器执行命令后返回码判断是否成功，如果是0则为健康。
- TCPSocketAction 通过对容器IP、端口进行TCP检查。如果端口开放则为健康。
- HTTPGetAction 通过对容器的IP、端口、路径进行HTTP Get检查，如果返回状态码为2xx或者3xx则为健康。

探测结果

- Success 容器通过了探针的探测检查
- Failure 容器不通过了探针的探测检查
- Unknow 无法探测检查，不采取任何动作

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx:1.16
    ports: 
    - containerPort: 80
    readinessProbe: 			#就绪探针
      exec:
        command: /data/check.sh
      initialDelaySeconds: 5 	#启动后延迟检测
      periodSeconds: 10 		#间隔的探测时间
    livenessProbe: 				#存活探针
      httpGet:
        path: /health
        port: 80
      initialDelaySeconds: 15 	#启动后延迟检测
      periodSeconds: 20 		#间隔的探测时间
    startupProbe: 				#启动探针
      tcpSocket: 
        port: 5672
      failureThreshold: 30 		#检测失败后重试次数
      periodSeconds: 10  		#间隔的探测时间
```

通用探针字段

- initialDelaySeconds Pod启动后延迟探测
- periodSeconds 间隔的探测时间
- timeoutSeconds 探测的超时时间
- successThreshold 检测失败后重试成功的次数，达到该次数后将认为success
- failureThreshold 检测失败后重试次数，达到该次数后将认为fail

http探针字段

- host 探测的主机名，默认为Pod IP
- port 探测的端口号，范围1-65535
- scheme 探测的方式，http或是https
- path 探测的http路径，例如/health
- httpHeaders 探测时http标头

exec探针字段

- command 探测的命令



### Pod的节点选择

在默认情况下，Pod会被Kuberentes调度到具有所需运行资源的节点上，可以通过标签选择、直接指定节点来选择运行的节点。

**通过节点标签绑定Pod**

```shell
$ kubectl label nodes k8s-c01-p002 environment=prod

$ kubectl get nodes --show-labels
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx:1.16
  nodeSelector: 
    environment: prod 	#指定匹配的标签
```

**通过节点名称绑定Pod**

```shell
$ kubectl apply -f nodename-selector.yaml
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  nodeName: k8s-c01-p003 #指定节点匹配
  containers:
  - name: nginx
    image: nginx:1.16
```



### 使用技巧

单独使用Pod并不能真正发挥Kubernetes的威力，所以一般不会直接进行Pod的创建，而是通过Deployment控制器来创建及管理Pod，这会让Pod实现故障自愈及滚动升级等功能。



### 参考

- [Kubernetes - 4.1 Workload - Pod](https://www.toutiao.com/i6799989806890746376/?group_id=6799989806890746376)