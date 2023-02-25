## Containerd安装

[TOC]



### 前置准备

**确认主机名称、IP、product_uuid 地址均唯一**

```shell
ip link
sudo cat /sys/class/dmi/id/product_uuid
```

**关闭 swap**

临时关闭

```shell
sudo swapoff -a
```

持久化关闭 swap 需要编辑 `/etc/fstab` 文件



### 安装containerd

#### 参数配置

**配置containerd**

```shell
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF
```

**加载overlay、br_netfilter模块**

```shell
sudo modprobe overlay
sudo modprobe br_netfilter
```

**设置必需的 sysctl 参数，这些参数在重新启动后仍然存在**

```shell
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
```

**不重启的情况下，应用sysctl参数**

```shell
sudo sysctl --system
```

#### 安装containerd

**安装所需包**

```shell
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
```

**新增 Docker 仓库**

```shell
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
```

**安装 containerd**

```shell
sudo yum install -y containerd.io
```

**配置 containerd**

```shell
# 创建配置文件目录
sudo mkdir -p /etc/containerd
# 设置默认配置
sudo containerd config default > /etc/containerd/config.toml
```

**重启 containerd**

```shell
sudo systemctl restart containerd
```



### k8s使用containerd的一些配置

**配置kubelet的cgroup**

> 设置cgroup为systemd方式

```shell
# config kubelet cgroup
cat > /etc/sysconfig/kubelet <<EOF
KUBELET_EXTRA_ARGS=--cgroup-driver=systemd
EOF
```

**配置CRI**

```shell
# config CRI
cat > /etc/crictl.yaml <<EOF
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 10
debug: false
EOF
```

**设置 runc 使用 systemd cgroup 驱动**

```shell
# 编辑配置文件
vi /etc/containerd/config.toml

# [plugins."io.containerd.grpc.v1.cri"] 下的 sandbox_image
# 修改为一个你可以获取到镜像的源地址，我这边随便从网上找了一个可用的
# 如果这个不可用自己去找一个能用的就行
sandbox_image="registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.1"

# 还有需要加上下面
在[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]中加入
  ...
  [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
    SystemdCgroup = true
```

**重启 containerd**

```shell
sudo systemctl restart containerd
```





### 参考

- [k8s(kubernetes)部署集群（containerd）2020年12月](https://www.cnblogs.com/codenoob/p/14098539.html)
- [kubeadm 安装 kubernetes containerd (附代理配置)](https://www.jianshu.com/p/6aa5c8d4eed6)

