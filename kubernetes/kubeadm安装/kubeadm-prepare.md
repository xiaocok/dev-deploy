# 安装环境准备

**官方文档地址：**

```shell
# kubeadm安装文档地址

# 1.19
https://v1-19.docs.kubernetes.io/zh/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

# 最新版
https://kubernetes.io/zh/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

# kubectl安装文档地址
https://v1-19.docs.kubernetes.io/zh/docs/tasks/tools/install-kubectl/
```



您需要在每台机器上安装以下的软件包：

- `kubeadm`：用来初始化集群的指令。
- `kubelet`：在集群中的每个节点上用来启动 pod 和容器等。
- `kubectl`：用来与集群通信的命令行工具。



## 准备开始

- 每台机器 2 GB 或更多的 RAM (如果少于这个数字将会影响您应用的运行内存)
- 2 CPU 核或更多
- 节点之中不可以有重复的主机名、MAC 地址或 product_uuid。请参见[这里](https://v1-19.docs.kubernetes.io/zh/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#verify-the-mac-address-and-product-uuid-are-unique-for-every-node) 了解更多详细信息。
- 开启机器上的某些端口。请参见[这里](https://v1-19.docs.kubernetes.io/zh/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#check-required-ports) 了解更多详细信息。
- 禁用交换分区。为了保证 kubelet 正常工作，您 **必须** 禁用交换分区。



## 环境准备

- 修改主机名

  ```shell
  hostnamectl set-hostname master
  hostnamectl set-hostname node1
  hostnamectl set-hostname node2
  ```

- 设置本地解析（vi /etc/hosts)

  ```shell
  192.168.33.100 master
  192.168.33.110 node1
  192.168.33.120 node2
  ```

- 关闭防火墙（测试环境）

  ```shell
  systemctl stop firewalld
  systemctl disable firewalld
  ```

- 设置selinux

  ```shell
  setenforce 0
  sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
  ```

  或者

  ```shell
  # 将 SELinux 设置为 permissive 模式（相当于将其禁用）
  setenforce 0
  sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
  ```

  通过运行命令 `setenforce 0` 和 `sed ...` 将 SELinux 设置为 permissive 模式可以有效的将其禁用。 这是允许容器访问主机文件系统所必须的，例如正常使用 pod 网络。 您必须这么做，直到 kubelet 做出升级支持 SELinux 为止。

- 关闭缓存

  禁用交换分区。为了保证 kubelet 正常工作，您 **必须** 禁用交换分区。

  ```shell
  #临时禁用
  swapoff -a
  
  #永久禁用，此处必须禁用，否则重启node后无法加入cluster
  #重点：注释：/etc/fstab的swap所在行
  swapoff -a										#临时关闭
  yes | cp /etc/fstab /etc/fstab_bak				#备份文件
  cat /etc/fstab_bak | grep -v swap > /etc/fstab	#注释对应行
  free -h											#查看是否关闭
  ```

  [kubernetes经典面试题：为啥k8s默认禁用了swap？](https://www.toutiao.com/i6986225497222939149)

  我们都知道swap的作用主要是将部分内存中匿名页置换到磁盘中，等到内存缺页异常的时候再交换回来，通过磁盘扩展内存空间。看似是个好东西，但k8s却默认禁用了。

  主要有两个方面原因：

  - 第一是因为性能问题，在生产环境我们经常会遇到容器性能突然降低的情况，查看原因后，大部分都是因为开启了swap导致的。swap看似解决了有限内存的问题，但这种通过时间换空间的做法也给性能带来了很大问题，尤其是在高并发场景中，很容易导致系统不稳定。

  - 第二是因为k8s定义的资源模型中，CPU和内存都是确定的可用资源，在调度的时候都会考虑在内。比如，设置了内存设置了limit 2G，就代表最大可用内存是2G，而引入swap（cgroup支持swap限制）后这个模型就变得复杂了，而且需要结合Qos，swap的使用完全是由操作系统根据水位自行调节的，并不直接受kubelet管理。

- 设置iptables不对bridge的数据进行处理

  一些 RHEL/CentOS 7 的用户曾经遇到过问题：由于 iptables 被绕过而导致流量无法正确路由的问题。您应该确保 在 `sysctl` 配置中的 `net.bridge.bridge-nf-call-iptables` 被设置为 1。

  ```bash
  cat <<EOF >  /etc/sysctl.d/k8s.conf
  net.bridge.bridge-nf-call-ip6tables = 1
  net.bridge.bridge-nf-call-iptables = 1
  EOF
  sysctl --system
  ```

  确保在此步骤之前已加载了 `br_netfilter` 模块。这可以通过运行 `lsmod | grep br_netfilter` 来完成。要显示加载它，请调用 `modprobe br_netfilter`。

  kubelet 现在每隔几秒就会重启，因为它陷入了一个等待 kubeadm 指令的死循环。

- 确保每个节点上 MAC 地址和 product_uuid 的唯一性

  您可以使用以下命令来获取网络接口的 MAC 地址

  ```shell
  ip link
  或者
  ifconfig -a
  ```

  可以使用以下命令对 product_uuid 校验

  ```shell
  sudo cat /sys/class/dmi/id/product_uuid
  ```

  一般来讲，硬件设备会拥有唯一的地址，但是有些虚拟机的地址可能会重复。Kubernetes 使用这些值来唯一确定集群中的节点。 如果这些值在每个节点上不唯一，可能会导致安装[失败](https://github.com/kubernetes/kubeadm/issues/31)。

- 确保 iptables 工具不使用 nftables 后端

  在 Linux 中，nftables 当前可以作为内核 iptables 子系统的替代品。 `iptables` 工具可以充当兼容性层，其行为类似于 iptables 但实际上是在配置 nftables。 nftables 后端与当前的 kubeadm 软件包不兼容：它会导致重复防火墙规则并破坏 `kube-proxy`。

  如果您系统的 `iptables` 工具使用 nftables 后端，则需要把 `iptables` 工具切换到“旧版”模式来避免这些问题。 默认情况下，至少在 Debian 10 (Buster)、Ubuntu 19.04、Fedora 29 和较新的发行版本中会出现这种问题。RHEL 8 不支持切换到旧版本模式，因此与当前的 kubeadm 软件包不兼容。

- 检查所需端口

  - 控制平面节点

    | 协议 | 方向 | 端口范围  | 作用                    | 使用者                       |
    | ---- | ---- | --------- | ----------------------- | ---------------------------- |
    | TCP  | 入站 | 6443*     | Kubernetes API 服务器   | 所有组件                     |
    | TCP  | 入站 | 2379-2380 | etcd server client API  | kube-apiserver, etcd         |
    | TCP  | 入站 | 10250     | Kubelet API             | kubelet 自身、控制平面组件   |
    | TCP  | 入站 | 10251     | kube-scheduler          | kube-scheduler 自身          |
    | TCP  | 入站 | 10252     | kube-controller-manager | kube-controller-manager 自身 |

  - 工作节点

    | 协议 | 方向 | 端口范围    | 作用            | 使用者                     |
    | ---- | ---- | ----------- | --------------- | -------------------------- |
    | TCP  | 入站 | 10250       | Kubelet API     | kubelet 自身、控制平面组件 |
    | TCP  | 入站 | 30000-32767 | NodePort 服务** | 所有组件                   |

    ** [NodePort 服务](https://v1-19.docs.kubernetes.io/zh/docs/concepts/services-networking/service/) 的默认端口范围。

    使用 * 标记的任意端口号都可以被覆盖，所以您需要保证所定制的端口是开放的。

    虽然控制平面节点已经包含了 etcd 的端口，您也可以使用自定义的外部 etcd 集群，或是指定自定义端口。

    您使用的 pod 网络插件 (见下) 也可能需要某些特定端口开启。由于各个 pod 网络插件都有所不同，请参阅他们各自文档中对端口的要求。



## 安装 runtime

**如果已安装了docker，则这里无需操作**



从 v1.6.0 版本起，Kubernetes 开始默认允许使用 CRI（容器运行时接口）。

从 v1.14.0 版本起，kubeadm 将通过观察已知的 UNIX 域套接字来自动检测 Linux 节点上的容器运行时。 下表中是可检测到的正在运行的 runtime 和 socket 路径。

| 运行时     | 域套接字                        |
| ---------- | ------------------------------- |
| Docker     | /var/run/docker.sock            |
| containerd | /run/containerd/containerd.sock |
| CRI-O      | /var/run/crio/crio.sock         |

如果同时检测到 docker 和 containerd，则优先选择 docker。 这是必然的，因为 docker 18.09 附带了 containerd 并且两者都是可以检测到的。 如果检测到其他两个或多个运行时，kubeadm 将以一个合理的错误信息退出。

在非 Linux 节点上，默认使用 docker 作为容器 runtime。

如果选择的容器 runtime 是 docker，则通过内置 `dockershim` CRI 在 `kubelet` 的内部实现其的应用。

基于 CRI 的其他 runtimes 有：

- [containerd](https://github.com/containerd/cri) （containerd 的内置 CRI 插件）
- [cri-o](https://cri-o.io/)
- [frakti](https://github.com/kubernetes/frakti)

请参考 [CRI 安装指南](https://v1-19.docs.kubernetes.io/zh/docs/setup/production-environment/container-runtimes/)获取更多信息。

