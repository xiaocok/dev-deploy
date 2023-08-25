

## 一、官方文档

https://v1-24.docs.kubernetes.io/zh-cn/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/



## 二、环境准备

[【k8s】一、基础实验环境准备](https://blog.csdn.net/zhh763984017/article/details/126714327)

[容器运行时](https://v1-24.docs.kubernetes.io/zh-cn/docs/setup/production-environment/container-runtimes/)



| 服务                                  | 版本    |
| ------------------------------------- | ------- |
| Kubernetus                            | v1.24.3 |
| Containerd                            | v1.6.16 |
| runc                                  | v1.1.4  |
| cni                                   | v1.2.0  |
| nerdctl                               | v1.2.0  |
| circtl                                | v1.24.2 |
| Flannel【镜像】                       | v0.20.2 |
| flannel-cni-plugin【镜像/本地命令行】 | v1.1.2  |
| Calico                                | v3.25   |



### 1、环境准备

> 对于插件开发人员以及时常会构建并部署 Kubernetes 的用户而言， 插件可能也需要特定的配置来支持 kube-proxy。 iptables 代理依赖于 iptables，插件可能需要确保 iptables 能够监控容器的网络通信。 例如，如果插件将容器连接到 Linux 网桥，插件必须将 `net/bridge/bridge-nf-call-iptables` sysctl 参数设置为 `1`，以确保 iptables 代理正常工作。 如果插件不使用 Linux 网桥，而是使用类似于 Open vSwitch 或者其它一些机制， 它应该确保为代理对容器通信执行正确的路由。



```shell
# 关闭防火墙
systemctl stop firewalld && \
systemctl disable firewalld

# 关闭 selinux
# 永久关闭（重启生效）
sed -i 's/enforcing/disabled/' /etc/selinux/config && \
# 临时关闭（即刻生效）
setenforce 0

# 关闭swap(k8s禁止虚拟内存以提高性能)
# 永久关闭（重启生效）
sed -ri 's/.*swap.*/#&/' /etc/fstab && \
# 临时关闭（即刻生效）
swapoff -a

# 在master添加hosts：注意节点名称和IP
cat >> /etc/hosts << EOF
192.168.137.200 k8s-master
192.168.137.201 k8s-node1
192.168.137.202 k8s-node2
EOF

# 设置hostname，master节点kube init初始化时。需要使用hostname
hostnamectl set-hostname k8s-master
```



### 2、转发 IPv4 并让 iptables 看到桥接流量

> 为了让 Linux 节点的 iptables 能够正确查看桥接流量，请确认 `sysctl` 配置中的 `net.bridge.bridge-nf-call-iptables` 设置为 1。

```shell
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
 
modprobe overlay
modprobe br_netfilter
 
# 设置所需的 sysctl 参数，参数在重新启动后保持不变
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# 网桥生效
sysctl --system

# 时间同步
yum install ntpdate -y && ntpdate time.windows.com
```



## 二、容器运行时

https://github.com/containerd/containerd

https://github.com/cri-o/cri-o

https://github.com/containernetworking/plugins



[Kubernetes - 容器运行时](https://v1-24.docs.kubernetes.io/zh-cn/docs/setup/production-environment/container-runtimes/)

[【k8s】二、containerd的安装](https://blog.csdn.net/zhh763984017/article/details/126714567)



### 1、安装容器运行时

#### (1) 安装containerd

> 当前最新版1.6.16

```shell
# 下载二进制包
$ curl -LO https://github.com/containerd/containerd/releases/download/v1.6.16/containerd-1.6.16-linux-amd64.tar.gz

# 解压到/usr/local目录下
$ tar Czxvf /usr/local containerd-1.6.16-linux-amd64.tar.gz

# 查看版本
$ ctr -v
ctr github.com/containerd/containerd v1.6.16
$ ctr version
Client:
  Version:  v1.6.16
  Revision: 31aa4358a36870b21a992d3ad2bef29e1d693bec
  Go version: go1.18.10
```

**配置成systemd任务**

```shell
$ mkdir -p /usr/local/lib/systemd/system/
$ curl -L https://raw.githubusercontent.com/containerd/containerd/v1.6.16/containerd.service -o /usr/local/lib/systemd/system/containerd.service
$ systemctl daemon-reload
$ systemctl start containerd
$ systemctl enable --now containerd
```

**配置containerd镜像源**

> 由于网络原因，我们无法直接访问k8s.gcr.io网站。因此我们修改containerd的配置文件`config.toml`配置一下containerd的镜像源

```shell
$ mkdir -p /etc/containerd

# 生成默认配置文件
$ containerd config default > /etc/containerd/config.toml

# 设置沙箱镜像
sed -i "s#registry.k8s.io/pause#registry.aliyuncs.com/google_containers/pause#g"  /etc/containerd/config.toml

# 设置containerd使用 systemd cgroup 驱动程序
sed -i 's#SystemdCgroup = false#SystemdCgroup = true#g' /etc/containerd/config.toml

# 修改镜像源
sed -i '/registry.mirrors]/a\ \ \ \ \ \ \ \ [plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]' /etc/containerd/config.toml  && \
sed -i '/registry.mirrors."docker.io"]/a\ \ \ \ \ \ \ \ \ \ endpoint = ["https://hub-mirror.c.163.com"]' /etc/containerd/config.toml && \
sed -i '/hub-mirror.c.163.com"]/a\ \ \ \ \ \ \ \ [plugins."io.containerd.grpc.v1.cri".registry.mirrors."k8s.gcr.io"]' /etc/containerd/config.toml  && \
sed -i '/"k8s.gcr.io"]/a\ \ \ \ \ \ \ \ \ \ endpoint = ["http://registry.aliyuncs.com/google_containers"]' /etc/containerd/config.toml

# restart containerd to reload config
systemctl restart containerd
```

> 至此，k8s的基础容器containerd环境已经安装完毕了，注意，containerd是每台节点机器都要进行安装的。这里只演示了`k8s-master`的部署。剩下的`k8s-node1`跟`k8s-node2`就由各位同学自行安装练习了。

#### (2) 安装runc

> runc是容器运行时：runc实现了容器的init，run，create，ps...我们在运行容器所需要的cmd

```shell
$ curl -LO https://github.com/opencontainers/runc/releases/download/v1.1.4/runc.amd64
$ install -m 755 runc.amd64 /usr/local/sbin/runc
```

#### (3) 安装cni

> CNI(Container Network Interface) 是一套容器网络接口规范，通过插件的形式支持各种各样的网络类型，而标准化的好处就是你只需一套标准json配置就可以为一个容器创建网络接口。

```shell
$ curl -JLO https://github.com/containernetworking/plugins/releases/download/v1.2.0/cni-plugins-linux-amd64-v1.2.0.tgz
$ mkdir -p /opt/cni/bin
$ tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.2.0.tgz

# 添加PATH路径至/etc/profile，添加cni网络插件的二进制文件至PATH路径
PATH=$PATH:/opt/cni/bin
export PATH

# 生效
source /etc/profile

# 重启containerd
systemctl restart containerd
```

#### (4) containerd命令行使用

containerd命令与docker的命令大同小异，只是containerd多了一个namespace的概念。

ctr help可以查看containerd的命令

```shell
# 查看namespace为baiyu下的镜像文件
ctr images ls ns baiyu

# 一般k8s的镜像都会下载在`k8s.io`这个命名空间下
ctr images ls ns k8s.io
```

> containerd 相比于docker , 多了namespace概念, 每个image和container 都会在各自的namespace下可见, 目前k8s会使用k8s.io 作为命名空间
>
> ctr是containerd自带的工具，有命名空间的概念，若是[k8s](https://so.csdn.net/so/search?q=k8s&spm=1001.2101.3001.7020)相关的镜像，都默认在k8s.io这个命名空间，所以导入镜像时需要指定命令空间为k8s.io

```shell
# 镜像标记tag
ctr -n k8s.io i tag registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.2 k8s.gcr.io/pause:3.2
ctr -n k8s.io i tag kafka-monitor:v1 kubebiz/kafka-monitor:v1

# 删除镜像
ctr -n k8s.io i rm k8s.gcr.io/pause:3.2

# 拉取镜像
ctr -n k8s.io i pull -k k8s.gcr.io/pause:3.2

# 推送镜像
ctr -n k8s.io i push -k k8s.gcr.io/pause:3.2

# 导出镜像
ctr -n k8s.io i export pause.tar k8s.gcr.io/pause:3.2

# 导入镜像
# 不支持 build,commit 镜像
ctr -n k8s.io i import pause.tar
ctr -n=k8s.io image import dashboard.tar

# 查看镜像，可以看到可以查询到了，如果未指定命令空间，则crictl images无法查看到镜像
crictl images

# 镜像导出、导入
ctr image export docker.io/library/hello-world:latest > hello-world.tar
ctr image import mysql8.tar.gz
```



#### (5) nerdctl工具安装及使用

> nerdctl工具，是containerd官方为了让docker用户无感切换到containerd而开发的命令行工具。也就是docker的命令可以直接在nerdctl上使用

[nerdctl的GitHub地址](https://github.com/containerd/nerdctl)

```shell
curl -LO https://github.com/containerd/nerdctl/releases/download/v1.2.0/nerdctl-1.2.0-linux-amd64.tar.gz
tar xzvf nerdctl-1.2.0-linux-amd64.tar.gz 
cp nerdctl /usr/local/bin/
rm -rf containerd-rootless* nerdctl
```



#### (6) crictl命令行

> crictl 是 CRI 兼容的容器运行时命令行接口，和containerd无关，由Kubernetes提供，可以使用它来检查和调试 k8s 节点上的容器运行时和应用程序。containerd自带的 `ctr` 命令仅用于调试，建议下载 `crictl`。

```shell
curl -LO https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.24.2/crictl-v1.24.2-linux-amd64.tar.gz
tar zxvf crictl-v1.24.2-linux-amd64.tar.gz -C /usr/local/bin
rm -rf crictl-v1.24.2-linux-amd64.tar.gz

# 用 containerd 作为 runtime 
cat <<EOF | sudo tee /etc/crictl.yaml
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 10
debug: false
EOF
```

**使用**

```shell
# 指定runtime
crictl --runtime-endpoint unix:///var/run/containerd/containerd.sock images
crictl --runtime-endpoint unix:///var/run/containerd/containerd.sock ps -a

# 配置文件设置好runtime后，则不需要指定runtime
crictl version
crictl images

# 查看信息
crictl info

# 查看运行中的进程
crictl ps

# 查看全部
crictl ps -a
crictl ps -all

# 显示最后运行
crictl ps -l

# 查看pod
crictl pods

# 根据标签，查看pods
crictl pods --label run=nginx

# 获取容器日志
crictl logs 87d3992f84f74

# 查看镜像
crictl images

# 删除镜像
crictl images rmi

# 打包、提交、拉取
ctr -n k8s.io i tag kafka-monitor:v1 kubebiz/kafka-monitor:v1
crictl push kubebiz/kafka-monitor:v1
crictl pull kubebiz/kafka-monitor:v1

# 停止所有容器
crictl ps |awk '{print $1}' |xargs -i crictl stop {}

# 提交一个镜像
crictl commit 1a442630f4a9 test/javaweb:0.0

# 启动容器
crictl start 3e025dd50a72d956c4f140...
```



### 2、简介原理

**★★该步骤前面已调整，无需再执行★★**

#### (1) Cgroup 驱动程序简介

> 在 Linux 上，[控制组（CGroup）](https://v1-24.docs.kubernetes.io/zh-cn/docs/reference/glossary/?all=true#term-cgroup) 用于限制分配给进程的资源。

> 一组具有可选资源隔离、审计和限制的 Linux 进程。Cgroup 是一个 Linux 内核特性，对一组进程的资源使用（CPU、内存、磁盘 I/O 和网络等）进行限制、审计和隔离。

当某个 Linux 系统发行版使用 [systemd](https://www.freedesktop.org/wiki/Software/systemd/) 作为其初始化系统时，初始化进程会生成并使用一个 root 控制组（`cgroup`），并充当 cgroup 管理器。 Systemd 与 cgroup 集成紧密，并将为每个 systemd 单元分配一个 cgroup。 你也可以配置容器运行时和 kubelet 使用 `cgroupfs`。 连同 systemd 一起使用 `cgroupfs` 意味着将有两个不同的 cgroup 管理器。

单个 cgroup 管理器将简化分配资源的视图，并且默认情况下将对可用资源和使用中的资源具有更一致的视图。 当有两个管理器共存于一个系统中时，最终将对这些资源产生两种视图。 在此领域人们已经报告过一些案例，某些节点配置让 kubelet 和 docker 使用 `cgroupfs`，而节点上运行的其余进程则使用 systemd； 这类节点在资源压力下会变得不稳定。

更改设置，令容器运行时和 kubelet 使用 `systemd` 作为 cgroup 驱动，以此使系统更为稳定。 对于 Docker，要设置 `native.cgroupdriver=systemd` 选项。

> 由于 kubeadm 把 kubelet 视为一个系统服务来管理，所以对基于 kubeadm 的安装， 我们推荐使用 `systemd` 驱动，不推荐 `cgroupfs` 驱动。



##### 配置containerd使用 `systemd` cgroup 驱动程序

[配置 `systemd` cgroup 驱动程序](https://v1-24.docs.kubernetes.io/zh-cn/docs/setup/production-environment/container-runtimes/#containerd-systemd)

结合 `runc` 使用 `systemd` cgroup 驱动，在 `/etc/containerd/config.toml` 中设置

```
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
  ...
  [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
    SystemdCgroup = true
```

如果你应用此更改，请确保重新启动 containerd：

```shell
sudo systemctl restart containerd
```

当使用 kubeadm 时，请手动配置 [kubelet 的 cgroup 驱动](https://v1-24.docs.kubernetes.io/zh-cn/docs/tasks/administer-cluster/kubeadm/configure-cgroup-driver/#configuring-the-kubelet-cgroup-driver)。

##### 重载沙箱（pause）镜像

在你的 [containerd 配置](https://github.com/containerd/containerd/blob/main/docs/cri/config.md)中， 你可以通过设置以下选项重载沙箱镜像：

```toml
[plugins."io.containerd.grpc.v1.cri"]
  sandbox_image = "k8s.gcr.io/pause:3.2"
```

一旦你更新了这个配置文件，可能就同样需要重启 `containerd`：`systemctl restart containerd`



#### (2) 配置 kubelet 的 cgroup 驱动

[配置 cgroup 驱动](https://v1-24.docs.kubernetes.io/zh-cn/docs/tasks/administer-cluster/kubeadm/configure-cgroup-driver/)

> kubeadm 支持在执行 `kubeadm init` 时，传递一个 `KubeletConfiguration` 结构体。 `KubeletConfiguration` 包含 `cgroupDriver` 字段，可用于控制 kubelet 的 cgroup 驱动。

```yaml
# kubeadm-config.yaml
kind: ClusterConfiguration
apiVersion: kubeadm.k8s.io/v1beta3
kubernetesVersion: v1.24.3
---
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
cgroupDriver: systemd
```

这样一个配置文件就可以传递给 kubeadm 命令了：

```shell
kubeadm init --config kubeadm-config.yaml
```

执行 `init`、`join` 和 `upgrade` 等子命令会促使 kubeadm 将 `KubeletConfiguration` 写入到文件 `/var/lib/kubelet/config.yaml` 中， 继而把它传递给本地节点的 kubelet。

Kubeadm 对集群所有的节点，使用相同的 `KubeletConfiguration`。 `KubeletConfiguration` 存放于 `kube-system` 命名空间下的某个 [ConfigMap](https://v1-24.docs.kubernetes.io/zh-cn/docs/concepts/configuration/configmap) 对象中。



## 三、安装集群

[【k8s】三、k8s集群的初始化](https://blog.csdn.net/zhh763984017/article/details/126863671)



### 1、安装 kubeadm命令行

> master节点和所有node节点都需要执行本步骤安装。其中kubectl可以在node节点上面不安装。

1. 添加k8s的阿里云yum源

   ```shell
   cat > /etc/yum.repos.d/kubernetes.repo << EOF
   [kubernetes]
   name=Kubernetes
   baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
   enabled=1
   gpgcheck=0
   repo_gpgcheck=0
   gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
   EOF
   ```

2. yum安装**`kubeadm` `kubelet` `kubectl`**

   > k8s部署工具的版本要跟我们要搭建的k8s集群的版本要相对应，此次我们安装的是1.24.3版本的，因此**`kubeadm`、`kubelet`、`kubectl`**的版本都要对应

   ```shell
   yum install kubelet-1.24.3 kubeadm-1.24.3 kubectl-1.24.3 -y
   ```

3. 启动kubelet

   ```shell
   systemctl start kubelet
   systemctl enable kubelet.service
   ```

4. 启用 kubectl 自动补齐

   ```shell
   yum install -y bash-completion
   source <(kubectl completion bash)
   
   # 当前用户
   echo "source <(kubectl completion bash)" >> ~/.bashrc
   
   # 全局用户
   kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
   ```

   

### 2、安装集群

```shell
# 查看需要那些镜像
kubeadm config images list
kubeadm config images list --kubernetes-version v1.24.3

# 拉取镜像
kubeadm config images pull --image-repository="registry.aliyuncs.com/google_containers" --kubernetes-version v1.24.3 --v=5

# 使用自定义配置拉取images
kubeadm config images pull --config kubeadm.conf

# 打印默认配置
kubeadm config print init-defaults
```



#### (1) 安装master节点

##### ① 命令行创建

通过**`kubeadm init`**命令，我们可以快速对master节点进行初始化

```shell
kubeadm init --apiserver-advertise-address=192.168.137.200 --image-repository registry.aliyuncs.com/google_containers --kubernetes-version=v1.24.3 --service-cidr=10.96.0.0/12 --pod-network-cidr=10.244.0.0/16 --v=5
```

> I0201 23:23:34.445917   18951 kubelet.go:218] the value of KubeletConfiguration.cgroupDriver is empty; setting it to "systemd"
>
> 默认不指定，则使用systemd为cgroupDriver

参数解析：

- apiserver-advertise-address API 服务器所在的地址，这里就是master节点的IP
- image-repository 配置拉取k8s镜像的容器仓库，我们配置的是阿里的一个镜像仓库
- kubernetes-version 指定k8s的版本。
- service-cidr 服务的虚拟 IP 地址另外指定 IP 地址段
- pod-network-cidr pod节点网络可以使用的 IP 地址段，这里使用10.244.0.0/16是因为后续使用flannel网络插件时的默认网段就是这个。

`service-cidr`和`pod-network-cidr`的IP地址段设置是依据你service和pod的容量决定的。

可以通过IP计算机算出网段的容量

https://tool.520101.com/wangluo/ipjisuan/

##### ② 配置文件创建

**生成默认配置**

```shell
kubeadm config print init-defaults > kubeadm.conf
```

**修改配置**

```yaml
apiVersion: kubeadm.k8s.io/v1beta3
bootstrapTokens:
- groups:
  - system:bootstrappers:kubeadm:default-node-token
  token: abcdef.0123456789abcdef
  ttl: 24h0m0s
  usages:
  - signing
  - authentication
kind: InitConfiguration
localAPIEndpoint:
  # 修改监听地址 advertiseAddress: 1.2.3.4
  advertiseAddress: 192.168.195.128
  bindPort: 6443
# 设置init节点的信息
nodeRegistration:
  criSocket: unix:///var/run/containerd/containerd.sock
  imagePullPolicy: IfNotPresent
  # 节点名称
  name: k8s-master
  # 污点情况
  taints: null
---
apiServer:
  timeoutForControlPlane: 4m0s
apiVersion: kubeadm.k8s.io/v1beta3
certificatesDir: /etc/kubernetes/pki
clusterName: kubernetes
controllerManager: {}
dns: {}
etcd:
  local:
    dataDir: /var/lib/etcd
# 修改镜像地址 imageRepository: k8s.gcr.io
imageRepository: registry.cn-hangzhou.aliyuncs.com/google_containers
kind: ClusterConfiguration
# 修改版本 kubernetesVersion: 1.24.0
kubernetesVersion: 1.24.3
networking:
  dnsDomain: cluster.local
  # 设置Pod的网络：flannel网络插件的默认网段
  podSubnet: 10.244.0.0/16
  serviceSubnet: 10.96.0.0/12
scheduler: {}
```

**创建集群**

```shell
kubeadm init --config kubeadm.conf --v=5
```



##### ③ 保存kubeconfig

根据输出提示

接下来我们配置一下master节点

> 要使非 root 用户可以运行 kubectl，请运行以下命令， 它们也是 `kubeadm init` 输出的一部分：

```bash
mkdir -p $HOME/.kube && \
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config && \
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

或者，如果你是 `root` 用户，则可以运行：

```bash
export KUBECONFIG=/etc/kubernetes/admin.conf
```

> kubeadm 对 `admin.conf` 中的证书进行签名时，将其配置为 `Subject: O = system:masters, CN = kubernetes-admin`。 `system:masters` 是一个例外的、超级用户组，可以绕过鉴权层（例如 RBAC）。 不要将 `admin.conf` 文件与任何人共享，应该使用 `kubeadm kubeconfig user` 命令为其他用户生成 kubeconfig 文件，完成对他们的定制授权。 更多细节请参见[为其他用户生成 kubeconfig 文件](https://v1-24.docs.kubernetes.io/zh-cn/docs/tasks/administer-cluster/kubeadm/kubeadm-certs#kubeconfig-additional-users)。



注意：如果是单master节点，需要去掉master节点的污点

**标签**

```shell
# 添加标签
kubectl label nodes node91.com node92.com storagenode=momo

# 删除标签
kubectl label nodes node91.com node92.com storagenode-
```

**污点**

```shell
# 调用说明
kubectl taint node [node] key=value[effect]   
     其中[effect] 可取值: [ NoSchedule | PreferNoSchedule | NoExecute ]
      NoSchedule:		一定不能被调度
      PreferNoSchedule: 尽量不要调度
      NoExecute: 		不仅不会调度, 还会驱逐Node上已有的Pod

# 添加污点
kubectl taint node node1 key1=value1:NoSchedule
kubectl taint node node1 key1=value1:NoExecute
kubectl taint node node1 key2=value2:NoSchedule

# 删除taint
kubectl taint node node1 key1:NoSchedule-  	# 这里的key可以不用指定value
kubectl taint node node1 key1:NoExecute-
kubectl taint node node1 key1-  			# 删除指定key所有的effect


#master节点设置taint
kubectl taint nodes master node-role.kubernetes.io/master=:NoSchedule

#master去污
kubectl taint nodes master node-role.kubernetes.io/master=:NoSchedule-

#去除污点，允许master节点部署pod
kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
```

##### ④ 生成永久kubeconfig

**脚本生成**

```shell
# 设置serviceaccount名称、脚本名称
export KUBE_CONFIG=xxxxx

# 执行生成kubeconfig脚本
kubectl create serviceaccount ${KUBE_CONFIG} -n default
kubectl create clusterrolebinding ${KUBE_CONFIG} --clusterrole=cluster-admin --serviceaccount=default:${KUBE_CONFIG}
cat  << eof | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  annotations:
    kubernetes.io/service-account.name: ${KUBE_CONFIG}
  name: ${KUBE_CONFIG}-token
  namespace: default
type: kubernetes.io/service-account-token
eof

mkdir -p /root/kubeconfig/

USER_TOKEN_NAME=${KUBE_CONFIG}-token
USER_TOKEN_VALUE=$(kubectl -n default get secret/${USER_TOKEN_NAME} -o=jsonpath='{.data.token}' | base64 --decode)
CURRENT_CONTEXT=$(kubectl config current-context)
CURRENT_CLUSTER=$(kubectl config view --raw -o=go-template='{{range .contexts}}{{if eq .name "'''${CURRENT_CONTEXT}'''"}}{{ index .context "cluster" }}{{end}}{{end}}')
CLUSTER_CA=$(kubectl config view --raw -o=go-template='{{range .clusters}}{{if eq .name "'''${CURRENT_CLUSTER}'''"}}"{{with index .cluster "certificate-authority-data" }}{{.}}{{end}}"{{ end }}{{ end }}')
CLUSTER_SERVER=$(kubectl config view --raw -o=go-template='{{range .clusters}}{{if eq .name "'''${CURRENT_CLUSTER}'''"}}{{ .cluster.server }}{{end}}{{ end }}')

cat << EOF > /root/kubeconfig/${KUBE_CONFIG}-config
apiVersion: v1
kind: Config
current-context: ${CURRENT_CONTEXT}
contexts:
- name: ${CURRENT_CONTEXT}
  context:
    cluster: ${CURRENT_CLUSTER}
    user: ${KUBE_CONFIG}
    namespace: default
clusters:
- name: ${CURRENT_CLUSTER}
  cluster:
    certificate-authority-data: ${CLUSTER_CA}
    server: ${CLUSTER_SERVER}
users:
- name: ${KUBE_CONFIG}
  user:
    token: ${USER_TOKEN_VALUE}
EOF
```

**手动生成**

> 例如serviceaccount为kubeconfig

```shell
# 用户名称
export USER=kubeconfig

# apiserver的入口地址
export KUBE_APISERVER=`kubectl config view -ojsonpath='{.clusters[0].cluster.server}'`
```



1. 生成serviceaccount

   ```shell
   kubectl create serviceaccount ${USER} -n default
   ```

   **yaml示例**

   ```yaml
   apiVersion: v1
   kind: ServiceAccount
   metadata:
     creationTimestamp: "2023-02-03T15:13:53Z"
     name: kubeconfig
     namespace: default
     resourceVersion: "23361"
     uid: deb05307-9b8c-4ba5-9c2e-a4298363f064
   ```

2. 生成secret

   创建于ServiceAccount关联的secret，名为kubeconfig-token，该secret只能使用yaml创建，无法通过命令创建

   ```shell
   kubectl apply -f kubeconfig-token-secret.yaml
   ```

   **yaml示例**

   ```yaml
   apiVersion: v1
   kind: Secret
   metadata:
     name: ${USER}-token
     namespace: default
     annotations:
       kubernetes.io/service-account.name: "kubeconfig"
   type: kubernetes.io/service-account-token
   ```

3. 创建clusterrolebinding

   将serviceaccount（kubefleet）用户绑定到clusterrole（cluster-admin）集群角色上

   ```shell
   kubectl create clusterrolebinding ${USER}sabindclusteradmin --clusterrole=cluster-admin --serviceaccount=default:${USER}
   ```

   **ClusterRoleBinding示例**

   ```yaml
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
      name: kubefleetsabindclusteradmin
    subjects:
    - kind: ServiceAccount
      name: kubeconfig
      namespace: default
    roleRef:
      kind: ClusterRole
      name: cluster-admin
      apiGroup: rbac.authorization.k8s.io
   ```

   **普通ClusterRole示例，指定了部分权限**

   ```yaml
   kind: ClusterRole
   apiVersion: rbac.authorization.k8s.io/v1
   metadata:
     name: mypod-cluster
   rules:
   - apiGroups: ["*"]
     resources: ["pods"]
     verbs: ["get", "watch", "list"]
   ```

   **管理员cluster-admin示例，拥有全部权限**

   ```yaml
   apiVersion: rbac.authorization.k8s.io/v1
   kind: ClusterRole
   metadata:
     annotations:
       rbac.authorization.kubernetes.io/autoupdate: "true"
     labels:
       kubernetes.io/bootstrapping: rbac-defaults
     name: cluster-admin
   rules:
   - apiGroups:
     - '*'
     resources:
     - '*'
     verbs:
     - '*'
   - nonResourceURLs:
     - '*'
     verbs:
     - '*'
   ```

4. 获取token

   ```shell
   kubectl describe secret ${USER}-token -n default
   
   TOKEN=$(kubectl -n default  get secrets ${USER}-token -o jsonpath={.data.token} | base64 -d)
   ```

5. 创建config文件

   ```shell
   # 备份原始kubeconfig
   cp /root/.kube/config /root/.kube/config_backup
   export KUBECONFIG_PATH=/root/.kube/config
   
   # 生成新的kubeconfig
   kubectl config set-cluster kubernetes --certificate-authority=/etc/kubernetes/pki/ca.crt --embed-certs=true --server=${KUBE_APISERVER} --kubeconfig=${KUBECONFIG_PATH}
   kubectl config set-credentials ${USER} --token="${TOKEN}" --kubeconfig=${KUBECONFIG_PATH}
   kubectl config set-context ${USER}@kubernetes --cluster=kubernetes --user=${USER} --kubeconfig=${KUBECONFIG_PATH}
   kubectl config use-context ${USER}@kubernetes --kubeconfig=${KUBECONFIG_PATH}
   ```

   

#### (2) 加入集群作为计算平面的node节点

根据 **`kubeadm init`** 之后的提示，我们知道Node节点加入集群的命令如下：

```bash
kubeadm join 192.168.137.200:6443 --token fm17us.mptry3ijamo9avr2 \
        --discovery-token-ca-cert-hash sha256:b87cda5b45265db24b29260060fe8e537abb5547604d865a957dc7a026eb36a6 \
        --v=5
```

如果没有令牌，可以通过在控制平面节点上运行以下命令来获取令牌：

```shell
kubeadm token list

[root@master network-scripts]# kubeadm token list
TOKEN                     TTL         EXPIRES                USAGES                   DESCRIPTION                                                EXTRA GROUPS
irqt84.voof8xa53cec58mf   23h         2023-08-24T22:32:18Z   authentication,signing   <none>                                                     system:bootstrappers:kubeadm:default-node-token
```

默认情况下，令牌会在 24 小时后过期。如果要在当前令牌过期后将节点加入集群， 则可以通过在控制平面节点上运行以下命令来创建新令牌：

```shell
kubeadm token create

[root@master network-scripts]# kubeadm token create
irqt84.voof8xa53cec58mf
```

> --discovery-token-ca-cert-hash参数不变，即新的加入命令如下：

```bash
kubeadm join 192.168.137.200:6443 --token irqt84.voof8xa53cec58mf \
        --discovery-token-ca-cert-hash sha256:b87cda5b45265db24b29260060fe8e537abb5547604d865a957dc7a026eb36a6 \
        --v=5
```



#### (3) 加入集群作为控制平面master节点

[k8s集群添加master节点提示control plane instance a cluster that doesn‘t have a stable controlPlaneEndpoint ad](https://blog.csdn.net/hedao0515/article/details/126342939)

[k8s 加入 node和master 节点报错记录](https://blog.csdn.net/weixin_44730648/article/details/126372714)

如果不是使用的配置文件方式创建集群`kubeadm init --config kubeadm.conf --v=5`，而是使用的命令`kubeadm init --apiserver-advertise-address=192.168.137.200 --image-repository registry.aliyuncs.com/google_containers --kubernetes-version=v1.24.3 --service-cidr=10.96.0.0/12 --pod-network-cidr=10.244.0.0/16 --v=5`创建的集群，那么一般创建集群完成后kubeadm-config中不会有controlplaneEndpoint这个配置，需要手动写入，否则无法加入集群。

**主master节点执行**

```bash
 kubectl -n kube-system edit cm kubeadm-config
```

> 添加：controlPlaneEndpoint: 192.168.195.129:6443

![image-20230818012539955](E:\WWW\dev-deploy\kubernetes\kubeadm安装\kubernetes-v1.24.3\README.assets\image-20230818012539955.png)

加入控制平面需要etcd等证书，因为是 master节点 需要加 --control-plane --certificate-key 参数 --certificate-key 参数可以在主master节点使用 

```bash
# 每次新增节点都需要执行一次
kubeadm init phase upload-certs --upload-certs

[upload-certs] Storing the certificates in Secret "kubeadm-certs" in the "kube-system" Namespace
[upload-certs] Using certificate key:
c5e57ec1b4be2f0fa054f0bd586d1032006fe90ceef797b710a9fb4a59cb7412
```

如果使用 `--upload-certs` 调用 `kubeadm init` 命令， 你也可以对控制平面节点调用带 `--certificate-key` 参数的 `join` 命令， **将自动证书复制到该节点**。也无需人为额外的生成与复制。

```bash
kubeadm join 192.168.137.200:6443 --token fm17us.mptry3ijamo9avr2 \
        --discovery-token-ca-cert-hash sha256:b87cda5b45265db24b29260060fe8e537abb5547604d865a957dc7a026eb36a6 \
        --control-plane \
        --certificate-key c5e57ec1b4be2f0fa054f0bd586d1032006fe90ceef797b710a9fb4a59cb7412
        --v=5
```



#### (4) 集群网络初始化（flannel）

回到master节点，输入**kubectl get nodes**命令，此时我们可以看到有三个节点

细心的同学可能会发现，我们节点是有了，但是节点的状态都是NotReady。这是因为集群的网络还没有配好，问题不大，我们接着走。

初始化我们的集群网络，在master节点执行如下命令

```bash
curl -O https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml && \
kubectl apply -f kube-flannel.yml
```

通过命令**`kubectl get pod -n kube-flannel`**查看flannel的Pod启动情况，等到flannel的pod的状态变为Running时，这时，我们用`kubeclt get nodes`命令就会发现，所有节点的状态都变为`Ready`了。

#### (5) 部署网络（Calico）

> Calico是一个纯三层网络，通过linux 内核的L3 forwarding来实现vRouter功能，区别于flannel等需要封包解包的网络协议

https://projectcalico.docs.tigera.io/getting-started/kubernetes/requirements

Calico v3.25 版本支持以下 Kubernetes 版本.

- v1.22
- v1.23
- v1.24

**下载资源文件**

```shell
curl -LO https://github.com/projectcalico/calico/blob/release-v3.25/manifests/calico.yaml
或者
curl -LO https://projectcalico.docs.tigera.io/v3.25/manifests/calico.yaml
```

**修改Pod网段的CIDR**

- 该yaml文件中默认CIDR为192.168.0.0/16，需要与初始化时kube-config.yaml中的配置一致，如果不同请下载该yaml修改后运行

- 如果是kubeadm部署的k8s，则对应项为 --pod-network-cidr=10.244.0.0/16

```shell
# 放开该处的代码，并设置CIDR为10.244.0.0/16，需要与kubeadm init初始化时指定的IP相同
# - name: CALICO_IPV4POOL_CIDR
#   value: "192.168.0.0/16"
- name: CALICO_IPV4POOL_CIDR
  value: "10.244.0.0/16"
```

**指定网卡**

- calico 自动探查互联网卡，如果有多块网卡，则可以配置用于互联的网络接口命名正则表达式，如上面的 eth0 (根据自己服务器的网络接口名修改)；

```shell
# Cluster type to identify the deployment type
  - name: CLUSTER_TYPE
    value: "k8s,bgp"
# 下面添加
  - name: IP_AUTODETECTION_METHOD
    value: "interface=eth0"
    # eth0为本地网卡名字
```

如果有多张网卡，并且不指定网卡，创建pod时可能会报错

**部署calico**

```shell
kubectl apply -f calico.yaml
```



或者以下地址：以下地址为当前最新版

```shell
curl -LO https://projectcalico.docs.tigera.io/manifests/calico.yaml
```



## 四、删除集群

### 1、删除节点

```shell
# 使用适当的凭证与控制平面节点通信，运行：
kubectl drain <node name> --delete-emptydir-data --force --ignore-daemonsets

# 在删除节点之前，请重置 kubeadm 安装的状态：
kubeadm reset
rm -rf $HOME/.kube/config

# 重置过程不会重置或清除 iptables 规则或 IPVS 表。如果你希望重置 iptables，则必须手动进行：
iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X

# 如果要重置 IPVS 表，则必须运行以下命令：
ipvsadm -C

# 现在删除节点：
kubectl delete node <node name>
```

如果你想重新开始，只需运行 `kubeadm init` 或 `kubeadm join` 并加上适当的参数。

### 2、清理控制平面

在控制平面主机上使用 `kubeadm reset` 来触发尽力而为的清理。



## 参考

[【k8s】一、基础实验环境准备](https://blog.csdn.net/zhh763984017/article/details/126714327)

[【k8s】二、containerd的安装](https://blog.csdn.net/zhh763984017/article/details/126714567)

[【k8s】三、k8s集群的初始化](https://blog.csdn.net/zhh763984017/article/details/126863671)

[使用 kubeadm 创建集群](https://v1-24.docs.kubernetes.io/zh-cn/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)

[容器运行时](https://v1-24.docs.kubernetes.io/zh-cn/docs/setup/production-environment/container-runtimes/)

[配置 cgroup 驱动](https://v1-24.docs.kubernetes.io/zh-cn/docs/tasks/administer-cluster/kubeadm/configure-cgroup-driver/)

[kubeadm使用本地镜像安装kubernetes 1.15.1全过程](https://blog.csdn.net/scwang18/article/details/100075236)

[k8s标签使用和MASTER节点 添加 去除污点](https://blog.csdn.net/weixin_42562106/article/details/124699309)

[crictl使用总结](https://blog.csdn.net/qq_36657175/article/details/128012559)

[使用crictl调试Kubernetes节点](https://www.coderdocument.com/docs/kubernetes/v1.14/tasks/monitoring_logging_debugging/debugging_kubernetes_nodes_with_crictl.html)

[crictl命令行大全](https://www.orchome.com/16617)

[k8s-calico网络插件安装](https://www.cnblogs.com/khtt/p/16563088.html)

[k8s安装calico网络插件](https://blog.csdn.net/m0_61237221/article/details/125217833)

[k8s安装calico网络](https://www.jianshu.com/p/2c436a0ffe7f)
