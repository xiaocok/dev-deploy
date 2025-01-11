# 使用Kind安装Kubernetes集群



[TOC]



## Kind 相比于 Minikube 有什么优势呢？

**基于 Docker 而不是虚拟化**

Kind 不是打包一个虚拟化镜像，而是直接讲 K8S 组件运行在 Docker。带来了什么好处呢？

1. 不需要运行 GuestOS 占用资源更低。
2. 不基于虚拟化技术，可以在 VM 中使用。
3. 文件更小，更利于移植。

**支持多节点 K8S 集群和 HA**

Kind 支持多角色的节点部署，你可以通过配置文件控制你需要几个 Master 节点，几个 Worker 节点，以更好的模拟生产中的实际环境。



## 环境准备

### Docker环境准备

1. 安装防火墙
2. [安装docker-ce](../../docker/docker-ce/CentOS安装.md)
3. [docker加速](../../docker/docker-ce/Docker加速.md)



### Kubernetes环境准备

#### 安装kubectl

> 为了使用kubectl命令操作集群

**下载地址**

https://github.com/kubernetes/kubernetes/releases

**最新版地址**

https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.23.md

**v1.20.0地址**

https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.20.md



#### 安装kind

**二进制安装**

```shell
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.10.0/kind-linux-amd64
chmod +x ./kind
cp ./kind /usr/local/sbin
```

**下载地址**

https://github.com/kubernetes-sigs/kind/releases/

**v0.10.0版本，支持Kubernetes v1.20.0版本**

https://github.com/kubernetes-sigs/kind/releases/download/v0.10.0/kind-linux-amd64



### kind命令

**常用命令**

```shell
kind version 			# 查看版本
kind create cluster		# 创建出一个单节点的K8S环境
kind delete cluster		# 删除键
kind get clusters		# 获取集群列表
```



## 创建集群

### 镜像准备

**使用docker加速后，可以快速拉取到镜像**

```shell
# 先使用docker加速，拉取镜像
docker pull kindest/node:v1.20.0
```

**编译node image来创建集群**

```shell
# 下载源码
$(go env GOPATH)/src/k8s.io/kubernetes

# 编译node镜像
kind build node-image

# 创建集群
kind create cluster --image kindest/node:latest
```



### 命令创建集群

```shell
# 默认名称
kind create cluster # Default cluster context name is `kind`.

# 指定名称
kind create cluster --name kind-2

# 使用kind创建，指定镜像
kind create cluster --image kindest/node:v1.20.0
```



### 根据Yaml创建集群

> 建议使用该方式安装，**注意：ApiServer的地址调整为实际的地址**

**vim kindcnf.yaml**

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  # 监听地址
  apiServerAddress: "127.0.0.1"
  # 监听端口，当启动多集群时，需要这里监听的端口不一致。
  apiServerPort: 6443
nodes:
# 多节点集群，默认安装的集群只带上了一个控制节点，这里设置了一个工作节点
# 角色控制节点(master)、工作节点(node)，镜像使用sha256的版本
- role: control-plane
  image: kindest/node:v1.24.0@sha256:4bec67ade4adfd316ff95545a015d3071b3607c73ec167f21cba77c00a6e38c5
- role: worker
  image: kindest/node:v1.24.0@sha256:4bec67ade4adfd316ff95545a015d3071b3607c73ec167f21cba77c00a6e38c5
containerdConfigPatches:
- |-
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]
    endpoint = ["https://registry.docker-cn.com"]
```

**使用config创建集群**

```shell
# 如果config中未指定image，则可以使用--image指定image
kind create cluster --name kind-cluster --config kindcnf.yaml --image kindest/node:v1.24.0
```

**配置说明：**

1. image 是可选项，因为需要指定版本，所以使用image，注意必须是<image-name>:<version>@<sha256code> 的形式，如果不在配置文件中指定吗，也可以在命令行中使用--image 来指定镜像，`kind create cluster --name xxxx --config kindcnf.yaml --image kindest/node:v1.20.0`
2. apiServerAddress: "127.0.0.1" 这里设置api server的监听IP，设置本地访问后，外部就无法访问API server了，如果需要外部访问apiserver，需要修改此处配置
3. 镜像代理，因为国内的原因，镜像经常拉不下来，使用- |-
    [plugins."io.containerd.grpc.v1.cri".registry.mirrors."<被代理的域名>"]
    endpoint = ["<国内镜像源地址>"] 来加快镜像下载

> 被代理的域名：hub.docker.com（web版本的docker官方仓库）或者docker.io（命令行docker仓库）
>
> endpoint也可以使用国内的其他docker加速：网易https://hub-mirror.c.163.com



**如何获取镜像的sha256值**

> 拉取镜像时，有信息

```shell
# docker pull kindest/node:v1.24.0
......
Digest: sha256:4bec67ade4adfd316ff95545a015d3071b3607c73ec167f21cba77c00a6e38c5
Status: Downloaded newer image for kindest/node:v1.24.0
docker.io/kindest/node:v1.24.0
```



```shell
docker pull kindest/node:v1.20.0
......
Digest: sha256:b40ecf8bcb188f6a0d0f5d406089c48588b75edc112c6f635d26be5de1c89040
Status: Downloaded newer image for kindest/node:v1.20.0
docker.io/kindest/node:v1.20.0
```

> inspect查看时，在RepoDigests属性中

```shell
docker inspect kindest/node:v1.20.0
[
    {
        "Id": "sha256:ad1bcd4daa6607940a897527b6e7479c523759ad17d7f26b3d0e088fc062fef5",
        "RepoTags": [
            "kindest/node:v1.20.0"
        ],
        "RepoDigests": [
            "kindest/node@sha256:b40ecf8bcb188f6a0d0f5d406089c48588b75edc112c6f635d26be5de1c89040"
        ],
        ......
    }
]
```



### 离线安装集群

```text
REPOSITORY                     TAG                  IMAGE ID       CREATED         SIZE
kindest/kindnetd               v20200725-4d6bea59   b77790820d01   17 months ago   117MB
kindest/haproxy                v20200708-548e36db   2a35acc4ff2f   18 months ago   24.5MB
kindest/node                   v1.20.0              ad1bcd4daa66   13 months ago   1.33GB
```

离线安装需要下载镜像：

kindest/node		安装k8s的node节点的镜像，以docker方式执行k8s的节点

kindest/haproxy   使用kind安装时，需要下载的镜像





#### **使用kubeadmConfig配置文件方式**

> 仅供参考，不推荐此方式

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
kubeadmConfigPatches:
- |
  apiVersion: kubeadm.k8s.io/v1beta1
  kind: ClusterConfiguration
  metadata:
	name: config
  networking:
	serviceSubnet: 10.0.0.0/16
  # 阿里云加速
  imageRepository: registry.aliyuncs.com/google_containers
  nodeRegistration:
	kubeletExtraArgs:
	  pod-infra-container-image: registry.aliyuncs.com/google_containers/pause:3.1
- |
  apiVersion: kubeadm.k8s.io/v1beta1
  kind: ClusterConfiguration
  metadata:
	name: config
  networking:
	serviceSubnet: 10.0.0.0/16
  imageRepository: registry.aliyuncs.com/google_containers
nodes:
# 节点的角色：控制节点
- role: control-plane
  # 设置启动参数
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  # 可以单独指定节点的镜像
  image: kindest/node:v1.16.4@sha256:b91a2c2317a000f3a783489dfb755064177dbc3a0b2f4147d50f04825d016f55
  # 将端口从节点映射到主机
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    # Optional, defaults to "0.0.0.0"
    listenAddress: "0.0.0.0"
    # Optional, defaults to tcp
    protocol: udp
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
  - containerPort: 16443
    hostPort: 16443
    protocol: TCP
  - containerPort: 2379
    hostPort: 2379
    protocol: TCP
                        
原文链接：https://blog.csdn.net/qq_34562093/article/details/123312786
- role: control-plane
# 工作节点
- role: worker
- role: worker
```

#### **暴露端口**

	nodes:
	- role: control-plane
	  extraPortMappings:
	    - containerPort: 30080
	      hostPort: 30080

> 有时候我们想暴露svc的端口给外部访问，因为kubernetes的节点是在docker容器中，所以还需要容器暴露svc的端口，外部才能通过宿主机访问。



#### **挂载文档**

```yaml
nodes:
- role: control-plane
  extraMounts:
	- containerPath: /etc/docker/daemon.json
	  hostPath: /etc/docker/daemon.json
	  readOnly: true
```



#### 导入镜像

```shell
# 导入docker镜像，会自动导入每一个node节点
kind load docker-image my-app:latest --name my-cluster

# 导入tar镜像二进制文件
kind load image-archive IMAGE.tar --name my-cluster

# 查看导入情况
kind get nodes
docker exec -it <node-name> crictl images
```

使用导入的镜像

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: go-notify
  namespace: default
spec:
  containers:
  - name: go-notify
    image: go-notify:latest
    # 这里需要指定镜像不存在才拉取，存在则使用当前镜像，否则依然会从docker官方仓库去拉取镜像，提示没有镜像，拉取失败
    imagePullPolicy: IfNotPresent
    volumeMounts:
    - name: config-volume
      mountPath: /app.toml
      subPath: app.toml
  volumes:
  - name: config-volume
    configMap:
      name: app-config
```





## 常用命令

**获取集群列表**

```shell
kind get clusters
kind
kind-2
```



**切换 kubectl 集群上下文**

```shell
kubectl cluster-info --context kind-kind	#切换 kubectl 集群上下文
kubectl cluster-info --context kind-kind-2
```

> 切换上下文之后，使用kubectl命令才是直接连接的对应的集群



**删除集群**

```shell
kind delete cluster					# 默认名称kind
kind delete cluster --name kind-2	# 指定名称
```



**重启集群**

```shell
docker stop test-drone-control-plane
docker start test-drone-control-plane
```



**加载docker镜像至集群**

**kind load docker-image**

**kind load image-archive**

```shell
# 加载my-custom-image-0和my-custom-image-1的docker镜像至kind的集群
kind load docker-image my-custom-image-0 my-custom-image-1

# 指定集群名称
kind load docker-image --name aguncn  nginx:1.16-alpine
kind load docker-image alpine:3.15 --name kind-cluster

# 从二进制文件加载至集群
kind load image-archive /my-image-archive.tar
```



**查看节点的镜像列表**

```shell
docker exec -it my-node-name crictl images
docker exec -it kind-cluster-control-plane crictl images
```

> my-node-name即为节点的名称（kubectl get nodes获取名称），不是集群的名称



**查看启动的容器**

```shell
docker exec kind-control-plane crictl ps
```



**导出集群日志**

```shell
# 导出至tmp目录
kind export logs
# Exported logs to: /tmp/396758314

# 导出至指定目录
kind export logs ./somedir
# Exported logs to: ./somedir
```



**crictl的一些命令**

https://github.com/kubernetes-sigs/cri-tools/releases

```shell
# 列出在cri-o/containerd中运行的所有Kubernetes容器
crictl --runtime-endpoint unix:///run/containerd/containerd.sock ps -a | grep kube | grep -v pause

# 查看容器的日志
crictl --runtime-endpoint unix:///run/containerd/containerd.sock logs CONTAINERID
```







## 创建多集群





## 多集群管理

### 多集群切换

```shell
kubectl cluster-info           					# 获取k8s集群信息
kubectl config view            					# 获取k8s集群管理配置信息，也就是 .kube/config 文件内容
kubectl config get-contexts    					# 查看集群列表的context信息，并选中当前的集群
kubectl config set-context minikube --user=minikube --cluster=minikube --namespace=demo  # 设置上下文
kubectl config set current-context minikube   	# 切换到名称为 minikube 的集群中
kubectl config use-context minikube           	# 切换到名称为 minikube 的集群中
```



### 设置集群角色

```shell

kubectl label nodes test1 node-role.kubernetes.io/master=       			# 设置 test1 为 master 角色
kubectl label nodes 192.168.0.92 node-role.kubernetes.io/node=  			# 设置 test2 为 node 角色
kubectl taint nodes test1 node-role.kubernetes.io/master=true:NoSchedule    # 设置 master 一般情况下不接受负载
kubectl taint nodes test1 node-role.kubernetes.io/master-        			# master运行pod
kubectl taint nodes test1 node-role.kubernetes.io/master=:NoSchedule   		# master不运行pod
```



### 设置kubectl shell命令自动补全

```shell
kubectl completion -h
sudo yum -y install bash-completion
source /usr/share/bash-completion/bash_completion
type _init_completion
echo 'source <(kubectl completion bash)' >> ~/.bashrc
source ~/.bashrc
```

参考：[自动补全](https://kubernetes.io/docs/tasks/tools/install-kubectl/#enabling-shell-autocompletion)



## 问题

### 证书续期

1. 找到 Kind 集群的控制平面容器名称,容器名称不一定是这个

   ```shell
   docker ps --filter "name=kind-cluster-control-plane"
   ```

2. 进入 Kind 控制平面的容器

   ```shell
   docker exec -it kind-cluster-control-plane /bin/bash
   ```

3. 在容器内使用以下命令来更新证书，先备份/etc/kubernetes目录

   ```shell
   # 查看证书时间
   kubeadm certs check-expiration
   
   # 更新证书
   kubeadm certs renew all
   ```

4. 在控制平面容器内，重启 Kubernetes 控制平面组件，使更新后的证书生效

   ```shell
   pkill kube-apiserver
   pkill kube-controller-manager
   pkill kube-scheduler
   ```

5. 复制更新后的 admin.conf 到主机（宿主机执行），先将宿主机上config备份一下

   ```shell
   # 在宿主机中执行，需要退出容器
   exit
   
   docker cp kind-cluster-control-plane:/etc/kubernetes/admin.conf ~/.kube/config
   ```

6. 修改拷贝过来的config配置

   > 将kind-cluster-control-plane修改为之前配置的地址：域名或者IP。
   >
   > 可以只改这一项，也可以按下面的方式修改

   ```yaml
   vi ~/.kube/config
   
   apiVersion: v1
   clusters:
   - cluster:
       certificate-authority-data: 
       # server: https://kind-cluster-control-plane:6443
       server: https://192.168.195.133:6443
     name: kind-cluster
   ```

   除了certificate-authority-data、client-certificate-data、client-key-data几个证书和认证相关的信息，其他的都可以换为以前的值

   ```yaml
   apiVersion: v1
   clusters:
   - cluster:
       certificate-authority-data: 
       server: https://192.168.195.133:6443
     name: kind-cluster
   contexts:
   - context:
       cluster: kind-cluster
       user: kubernetes-admin
     name: kubernetes-admin@kind-cluster
   current-context: kubernetes-admin@kind-cluster
   kind: Config
   preferences: {}
   users:
   - name: kubernetes-admin
     user:
       client-certificate-data: 
       client-key-data: 
   ```

7. 重启docker容器

   ```shell
   # 重启master和节点，节点可能也需要更新证书
   docker restart kind-cluster-control-plane
   docker restart kind-cluster-worker
   ```

8. 验证

   ```shell
   kubectl get pod -A
   ```

   

## 参考

- [Kind - Quick Start](https://kind.sigs.k8s.io/docs/user/quick-start/)
- [Kubernetes/K8S快速入门之Kind](https://www.psvmc.cn/article/2021-02-27-kubernetes-start-3-kind.html)
- [Kind 安装单机k8s——windows](https://www.jianshu.com/p/d42cfa67fa84)
- [Kubernetes crictl管理命令详解](https://blog.csdn.net/xixihahalelehehe/article/details/116591151)
- [k8s crictl/ctr 命令总结](https://zhuanlan.zhihu.com/p/381545137)
- [Kind部署的K8s证书过期后的解决方案](https://blog.csdn.net/qq_31292011/article/details/142822366)