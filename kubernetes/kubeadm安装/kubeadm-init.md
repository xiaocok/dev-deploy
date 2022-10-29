## 部署Kubernetes集群

[TOC]

```shell
# kubeadm init命令行
https://v1-19.docs.kubernetes.io/zh/docs/reference/setup-tools/kubeadm/kubeadm-init/
```



### 初始化控制平面节点

控制平面节点是运行控制平面组件的机器， 包括 [etcd](https://v1-19.docs.kubernetes.io/zh/docs/tasks/administer-cluster/configure-upgrade-etcd/) （集群数据库） 和 [API Server](https://v1-19.docs.kubernetes.io/zh/docs/reference/command-line-tools-reference/kube-apiserver/) （命令行工具 [kubectl](https://v1-19.docs.kubernetes.io/docs/user-guide/kubectl-overview/) 与之通信）。

1. （推荐）如果计划将单个控制平面 kubeadm 集群升级成高可用， 你应该指定 `--control-plane-endpoint` 为所有控制平面节点设置共享端点。 端点可以是负载均衡器的 DNS 名称或 IP 地址。
2. 选择一个Pod网络插件，并验证是否需要为 `kubeadm init` 传递参数。 根据你选择的第三方网络插件，你可能需要设置 `--pod-network-cidr` 的值。 请参阅 [安装Pod网络附加组件](https://v1-19.docs.kubernetes.io/zh/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#pod-network)。
3. （可选）从版本1.14开始，`kubeadm` 尝试使用一系列众所周知的域套接字路径来检测 Linux 上的容器运行时。 要使用不同的容器运行时， 或者如果在预配置的节点上安装了多个容器，请为 `kubeadm init` 指定 `--cri-socket` 参数。 请参阅[安装运行时](https://v1-19.docs.kubernetes.io/zh/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-runtime)。
4. （可选）除非另有说明，否则 `kubeadm` 使用与默认网关关联的网络接口来设置此控制平面节点 API server 的广播地址。 要使用其他网络接口，请为 `kubeadm init` 设置 `--apiserver-advertise-address=<ip-address>` 参数。 要部署使用 IPv6 地址的 Kubernetes 集群， 必须指定一个 IPv6 地址，例如 `--apiserver-advertise-address=fd00::101`
5. （可选）在 `kubeadm init` 之前运行 `kubeadm config images pull`，以验证与 gcr.io 容器镜像仓库的连通性。



### 部署集群

#### 关于镜像拉取

**查看所需镜像列表**

```shell
# 使用配置文件方式
# kubeadm config images list --config kubeadm.yml

# 使用参数方式
# kubeadm config images list --kubernetes-version v1.21.3

k8s.gcr.io/kube-apiserver:v1.21.3
k8s.gcr.io/kube-controller-manager:v1.21.3
k8s.gcr.io/kube-scheduler:v1.21.3
k8s.gcr.io/kube-proxy:v1.21.3
k8s.gcr.io/pause:3.4.1
k8s.gcr.io/etcd:3.4.13-0
k8s.gcr.io/coredns/coredns:v1.8.0
```

**1.19.13**

```shell
# 官方镜像
k8s.gcr.io/kube-apiserver:v1.19.13
k8s.gcr.io/kube-controller-manager:v1.19.13
k8s.gcr.io/kube-scheduler:v1.19.13
k8s.gcr.io/kube-proxy:v1.19.13
k8s.gcr.io/pause:3.2
k8s.gcr.io/etcd:3.4.13-0
k8s.gcr.io/coredns:1.7.0

# https://hub.docker.com副本
mirrorgooglecontainers/kube-apiserver:v1.19.13
mirrorgooglecontainers/kube-controller-manager:v1.19.13
mirrorgooglecontainers/kube-scheduler:v1.19.13
mirrorgooglecontainers/kube-proxy:v1.19.13
mirrorgooglecontainers/pause:3.2
mirrorgooglecontainers/etcd:3.4.13-0
coredns/coredns:1.7.0

# 阿里云副本
registry.aliyuncs.com/google_containers/kube-apiserver:v1.19.13
registry.aliyuncs.com/google_containers/kube-controller-manager:v1.19.13
registry.aliyuncs.com/google_containers/kube-scheduler:v1.19.13
registry.aliyuncs.com/google_containers/kube-proxy:v1.19.13
registry.aliyuncs.com/google_containers/pause:3.2 
registry.aliyuncs.com/google_containers/etcd:3.4.13-0
registry.aliyuncs.com/google_containers/coredns:1.7.0
```

**1.21.3**

```shell
# 官方镜像
k8s.gcr.io/kube-apiserver:v1.21.3
k8s.gcr.io/kube-controller-manager:v1.21.3
k8s.gcr.io/kube-scheduler:v1.21.3
k8s.gcr.io/kube-proxy:v1.21.3
k8s.gcr.io/pause:3.4.1
k8s.gcr.io/etcd:3.4.13-0
k8s.gcr.io/coredns/coredns:v1.8.0

# https://hub.docker.com副本
mirrorgooglecontainers/kube-apiserver:v1.21.1
mirrorgooglecontainers/kube-controller-manager:v1.21.1
mirrorgooglecontainers/kube-scheduler:v1.21.1
mirrorgooglecontainers/kube-proxy:v1.21.1
mirrorgooglecontainers/pause:3.4.1
mirrorgooglecontainers/etcd:3.4.13-0
coredns/coredns:1.8.0

# 阿里云副本
registry.aliyuncs.com/google_containers/kube-apiserver:v1.21.1
registry.aliyuncs.com/google_containers/kube-controller-manager:v1.21.1
registry.aliyuncs.com/google_containers/kube-scheduler:v1.21.1
registry.aliyuncs.com/google_containers/kube-proxy:v1.21.1
registry.aliyuncs.com/google_containers/pause:3.4.1
registry.aliyuncs.com/google_containers/etcd:3.4.13-0
registry.aliyuncs.com/google_containers/coredns:1.8.0
# 注意：coredns需要拉取coredns:1.8.0，然后修改tag为coredns:v1.8.0
# 原因：
# 从1.19和1.21版本来看。老版本使用的是coredns:1.7.0，新版本使用的是v1.8.0。新版本增加了一个v标识。
# 阿里云的镜像仓库按老版本并没有对coredns增加一个v标识。因此安装时，安装kubeadm直接替换仓库的方式会拉取coredns:v1.8.0镜像。则会提示无法下载coredns:v1.8.0镜像。所以需要对阿里云的coredns:1.8.0镜像，修改tag为coredns:v1.8.0才能安装。
```

- 官方镜像，可能无法拉取

- hub.docker.com镜像

  需要手动拉取之后，在修改tag为官方镜像，再部署

  注意：coredns的镜像地址(coredns/coredns) 与 其他几个镜像的地址(mirrorgooglecontainers)不同

- 验证阿里云的镜像加速

  ```shell
  docker pull registry.aliyuncs.com/google_containers/kube-apiserver:v1.19.13
  ```

  如果加速中没有该镜像，则无法部署此版本的kubernetes

  如果个别镜像不存在的话，例如：coredns，可以通过hub.docker.com拉取下来，再修改tag为阿里云的镜像



- 部署前，拉取镜像

  ```shell
  kubeadm config images pull --image-repository registry.aliyuncs.com/google_containers --kubernetes-version v1.19.13
  ```

  ```shell
  kubeadm config images pull --image-repository registry.aliyuncs.com/google_containers --kubernetes-version v1.21.3
  ```

  注意：v1.21.3版本的的阿里云镜像registry.aliyuncs.com/google_containers/coredns:`v1.8.0`没有，

  从registry.aliyuncs.com/google_containers/coredns:`1.8.0`拉取后，

  修改tag为阿里云镜像registry.aliyuncs.com/google_containers/coredns:`v1.8.0`之后kubeadm init部署集群。

  [阿里云coredns:v1.8.0镜像不存在](https://blog.csdn.net/a749227859/article/details/118732605)

####　执行部署命令

`1.19.13`版本

```shell
kubeadm init \
    --apiserver-advertise-address=192.168.33.100 \
    --control-plane-endpoint=192.168.33.100:6443 \
    --image-repository registry.aliyuncs.com/google_containers \
    --kubernetes-version v1.19.13 \
    --service-cidr=10.1.0.0/16 \
    --pod-network-cidr=10.244.0.0/16 \
    --ignore-preflight-errors=all \
    --v=5
```

如果执行失败，则日志级别设置为6（--v=6），可以看详细日志。

如果是`1.21.3`版本，则将版本设置为--kubernetes-version v1.21.3即可。

```shell
# 拉取coredns镜像
docker pull registry.aliyuncs.com/google_containers/coredns:1.8.0

# 修改tag
docker tag registry.aliyuncs.com/google_containers/coredns:1.8.0 registry.aliyuncs.com/google_containers/coredns:v1.8.0

# 安装集群
kubeadm init \
    --apiserver-advertise-address=192.168.33.100 \
    --control-plane-endpoint=192.168.33.100:6443 \
    --image-repository registry.aliyuncs.com/google_containers \
    --kubernetes-version v1.21.3 \
    --service-cidr=10.1.0.0/16 \
    --pod-network-cidr=10.244.0.0/16 \
    --ignore-preflight-errors=all \
    --v=6
```



1. **--apiserver-advertise-address**

   指明master的那个interface与cluster与其他节点通信（如果mstaer有多个interface建议明确指定，如果不指定，kubeadm会自动选择有默认网关的interface）

   API 服务器所公布的其正在监听的 IP 地址。如果不指定，则会自动检测网络接口，通常是内网IP。

2. **--control-plane-endpoint**

   Api-Server的地址，为控制平面指定一个稳定的 IP 地址或 DNS 名称。

3. **--pod-network-cidr**

   指定 Pod 网络的范围。Kubernetes 支持多种网络方案，而且不同网络方案对 --pod-network-cidr 有自己的要求。

   此处使用的是flanel网络，所以必须这个CIDR设置为10.244.0.0/16。

   比如我在本文中使用的是Calico网络，需要指定为192.168.0.0/16。

4. **--service-cidr**

   用于指定SVC（kubernets的service）的网络范围

5. **--image-repository**

   Kubenetes默认Registries地址是 k8s.gcr.io，在国内并不能访问 gcr.io，在1.13版本中我们可以增加–image-repository参数，默认值是 k8s.gcr.io，将其指定为阿里云镜像地址：registry.aliyuncs.com/google_containers。

6. **--kubernetes-version**
   关闭版本探测，因为它的默认值是stable-1，会导致从https://dl.k8s.io/release/stable-1.txt下载最新的版本号，我们可以将其指定为固定版本来跳过网络请求。

7. **--ignore-preflight-errors=all**

   忽略错误

8. **--v**

   日志级别，--v=5默认级别, --v=6调试日志。如果异常时，可以设置为调试日志，方便查看问题。

   

- 初始化过程

  1. kubeadm 执行初始化前的检查。
  2. 生成 token 和证书。
  3. 生成 KubeConfig 文件，kubelet 需要这个文件与 Master 通信。
  4. 安装 Master 组件，会从 goolge 的 Registry 下载组件的 Docker 镜像（或者设置的代理的Registry ），这一步可能会花一些时间，主要取决于网络质量。
  5. 安装附加组件 kube-proxy 和 kube-dns。
  6. Kubernetes Master 初始化成功。
  7. 提示如何配置 kubectl，后面会实践。
  8. 提示如何安装 Pod 网络，后面会实践。
  9. 提示如何注册其他节点到 Cluster，后面会实践。

- 安装成功

  安装信息

  ```shell
  # 安装的yml文件地址
  /etc/kubernetes/manifests/kube-apiserver.yaml
  /etc/kubernetes/manifests/kube-controller-manager.yaml
  /etc/kubernetes/manifests/kube-scheduler.yaml
  /etc/kubernetes/manifests/etcd.yaml
  
  # 生成的证书
  /var/lib/kubelet/pki/kubelet-client-current.pem
  
  # kubelet配置文件，包含证书信息
  /etc/kubernetes/kubelet.conf
  ```

  **后续操作**

  ```shell
  # 要开始使用集群，要使非 root 用户可以运行 kubectl，请运行以下命令
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
  
  # 或者，如果你是 root 用户，则可以运行：
  export KUBECONFIG=/etc/kubernetes/admin.conf
  
  
  # 现在应该在集群中部署一个pod网络。
  # 以下是官方的插件地址，选择其中一个插件，执行命令“kubectl apply-f[podnetwork].yaml”安装网络插件
  https://kubernetes.io/docs/concepts/cluster-administration/addons/
  
  # 加入控制面板和加入节点
  # 使用管理员身份执行以下命令，通过复制证书的方式加入其他控制面板(kubelet)，和使用密钥的方式将其他节点加入集群
  kubeadm join 192.168.33.100:6443 \
  	--token m30ouq.zlhsacvdp1mwrjy4 \
      --discovery-token-ca-cert-hash \
      sha256:cba621c95049b4fe5d4623c6e979e430bf569c22bfd3d079a98e8ea26483a685 \
      --control-plane
  
  # 仅仅加入节点，不加入控制面板
  # 使用管理员身份执行以下命令，使用密钥仅加入节点
  kubeadm join 192.168.33.100:6443 \
  	--token m30ouq.zlhsacvdp1mwrjy4 \
      --discovery-token-ca-cert-hash \
      sha256:cba621c95049b4fe5d4623c6e979e430bf569c22bfd3d079a98e8ea26483a685
  ```

  **调度**

  ```shell
  # 允许master节点部署pod：所有master节点都允许被调度
  kubectl taint nodes --all node-role.kubernetes.io/master-
  
  # 将Master也当作Node使用：指定master节点允许被调度
  kubectl taint node nodename node-role.kubernetes.io/master-
  
  # 设置节点不允许被调度
  kubectl taint nodes nodename node-role.kubernetes.io/master=:NoSchedule
  
  # 将Master恢复成Master Only状态：
  kubectl taint node nodename node-role.kubernetes.io/master="":NoSchedule
  ```

  taint污点说明
  
  ```shell
  # 增加一个污点
  kubectl taint nodes node1 key1=value1:NoSchedule
  # 给节点 node1 增加一个污点，它的键名是 key1，键值是 value1，效果是 NoSchedule。
  # 这表示只有拥有和这个污点相匹配的容忍度的 Pod 才能够被分配到 node1 这个节点。
  
  # 移除一个污点
  kubectl taint nodes node1 key1=value1:NoSchedule-
  ```
  
  
  
  

#### 问题

**执行kuebel命令，报错无法连接**

```shell
报错：
	The connection to the server localhost:8080 was refused - did you specify the right host or port?
原因：
	kubernetes master没有与本机绑定，集群初始化的时候没有绑定，此时设置在本机的环境变量即可解决问题。
	一般是由于没有执行init之后的后续操作，或者普通用户和root用户切换了，导致异常。
解决：
	方式一：
		官方的方式
		#普通用户
        mkdir -p $HOME/.kube
        sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
        sudo chown $(id -u):$(id -g) $HOME/.kube/config
        
        #root用户
        export KUBECONFIG=/etc/kubernetes/admin.conf
	方式二：
        https://blog.csdn.net/CEVERY/article/details/108753379

        #设置环境变量
        编辑文件设置 vim /etc/profile 在底部增加新的环境变量 
            export KUBECONFIG=/etc/kubernetes/admin.conf
        或者
            echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> /etc/profile

        # 使生效
        source /etc/profile
```

**服务器重启，导致kuebeadm对应的服务停止了**

解决：

```shell
# 启动已停止的k8s相关的容器
docker start `docker ps -a |grep k8s_ | grep Exited|awk '{print $1}'`

# 记得启动kubelet，否则k8s集群认为系统不可调度，而无法去掉node.kubernetes.io/unreachable:NoSchedule污点
systemctl start kubelet.service
```



#### 安装网络插件

否则kube-controller-manager、kube-scheduler一直重启，集群Node状态一直为NotReady。

```shell
#默认的flannel的镜像地址为
quay.io/coreos/flannel:v0.14.0

#加速
#官方docker pull拉取太慢，使用导入方式
#releases地址：
https://github.com/flannel-io/flannel/releases
#dockers镜像下载：
https://github.com/flannel-io/flannel/releases/download/v0.14.0/flanneld-v0.14.0-amd64.docker
#导入镜像
docker load -i flanneld-v0.14.0-amd64.docker

#修改tag
docker tag quay.io/coreos/flannel:v0.14.0-amd64 quay.io/coreos/flannel:v0.14.0

#安装网络插件flannel
kubectl apply -f kube-flannel.yml
```

检测集群状态

```shell
#查看集群节点
$ kubectl get nodes
NAME         STATUS   ROLES                  AGE   VERSION
k8s-master   Ready    control-plane,master   44m   v1.21.3

#节点详情，节点异常查看
kubectl describe nodes

#查看k8s的系统级别的pod，用于排查问题
$ kubectl get pods -n kube-system
NAME                                 READY   STATUS    RESTARTS   AGE
coredns-59d64cd4d4-bmfsp             1/1     Running   0          62m
coredns-59d64cd4d4-llbwq             1/1     Running   0          62m
etcd-k8s-master                      1/1     Running   1          64m
kube-apiserver-k8s-master            1/1     Running   1          63m
kube-controller-manager-k8s-master   1/1     Running   13         63m
kube-flannel-ds-9cmss                1/1     Running   2          51m
kube-proxy-bdl7b                     1/1     Running   1          62m
kube-scheduler-k8s-master            1/1     Running   9          64m
```

重置kubeadm

```shelll
kubeadm reset
```

常见问题

```shell
1. 集群系统Pod的coredns一直没有ready
# kubectl get pod -n kube-system
NAME                                   READY
coredns-5c98db65d4-f9rb7               0/1

2. kube-controller-manager、kube-scheduler一直重启
# docker ps -a
CONTAINER ID   STATUS                        PORTS     NAMES
d7aa2a2c520f   Exited (255) 14 minutes ago             k8s_kube-scheduler
7b495118975a   Exited (255) 14 minutes ago             k8s_kube-controller-manager

3. container runtime network not ready: NetworkReady=false
# kubectl describe nodes
Conditions:
  Type             Reason                       Message
  ----             ------                       -------
  Ready            KubeletNotReady              container runtime network not ready: NetworkReady=false reason:NetworkPluginNotReady message:docker: network plugin is not ready: cni config uninitialized

出现这个错误提示信息已经很明显,网络插件没有准备好。
我们可以执行命令docker images|grep flannel来查看flannel镜像是否已经成功拉取下来。
经过排查,flannel镜像拉取的有点慢,稍等一会以后就ok了。

或者
从官方的镜像中导入
releases地址：
	https://github.com/flannel-io/flannel/releases
dockers镜像下载：
	https://github.com/flannel-io/flannel/releases/download/v0.14.0/flanneld-v0.14.0-amd64.docker
导入镜像：
	dockers load -i flanneld-v0.14.0-amd64.docker
修改tag:
	docker tag quay.io/coreos/flannel:v0.14.0-amd64 quay.io/coreos/flannel:v0.14.0
```

参考：

- [kubernetes安装过程中遇到问题及解决](https://www.cnblogs.com/tylerzhou/p/10974940.html)

- [quay.io国内无法访问，解决Kubernetes应用flannel失败，报错Init:ImagePullBackOff](https://blog.csdn.net/qq_43442524/article/details/105298366)

- [污点和容忍度](https://kubernetes.io/zh/docs/concepts/scheduling-eviction/taint-and-toleration/)

- [k8s Pod调度失败（NoExecute）排查及分析](https://blog.csdn.net/u012516914/article/details/110020568)



### 其他设置

#### 控制平面节点隔离

默认情况下，出于安全原因，你的集群不会在控制平面节点上调度 Pod。 如果你希望能够在控制平面节点上调度 Pod， 例如用于开发的单机 Kubernetes 集群，请运行：

```she
kubectl taint nodes --all node-role.kubernetes.io/master-
```



### 常用kubeadm命令

```shell
kubeadm config images list			#列出kubeadm所需的镜像
kubeadm config images pull			#拉取kubeadm所需的镜像
kubeadm config print 				#打印默认配置
kubeadm config print init-defaults 	#用于 'kubeadm init' 的默认 init 配置对象
kubeadm config print join-defaults	#用于 'kubeadm join' 的默认 join 配置对象
kubeadm config migrate 				#旧版本的配置转化成新版本
kubeadm join						#加入集群
kubeadm reset						#重置集群
```

