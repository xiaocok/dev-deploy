# 安装扩展（Addons）

[TOC]

**官方地址**

```shell
# 安装 Pod 网络附加组件
https://v1-19.docs.kubernetes.io/zh/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#pod-network

# 集群网络系统
https://v1-19.docs.kubernetes.io/zh/docs/concepts/cluster-administration/networking/

# Calico
https://docs.projectcalico.org/about/about-calico
https://docs.projectcalico.org/getting-started/kubernetes/self-managed-onprem/

# Flannel 
https://github.com/flannel-io/flannel#flannel
https://github.com/flannel-io/flannel/blob/master/Documentation/kube-flannel.yml

# Kube-router 
https://github.com/cloudnativelabs/kube-router

# 安装扩展（Addons）
https://v1-19.docs.kubernetes.io/zh/docs/concepts/cluster-administration/addons/

# 集群网络系统
https://v1-19.docs.kubernetes.io/zh/docs/concepts/cluster-administration/networking/
```





## 安装 Pod 网络附加组件

###　网络插件flannel安装

当前安装版本为：flannel v0.14.0

**Github地址**

```shell
https://github.com/flannel-io/flannel
```

**Kubernetes v1.17+使用以下命令**

```shell
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

即为：以下路径的文件内容

```shell
https://github.com/flannel-io/flannel/blob/master/Documentation/kube-flannel.yml
```

已下载于本地文件：

[kube-flannel.yml](kube-flannel.yml)

**此处1.19版本即可执行**

```shell
kubectl apply -f kube-flannel.yml
```

此处1.21版本即可执行

```shell
kubectl apply -f kube-flannel.yml
```





### 网络插件Calico

**地址**

```shell
https://github.com/projectcalico/calico
https://docs.projectcalico.org/getting-started/kubernetes/self-managed-onprem/onpremises
```

**Kubernetes50个节点以下，包含50个节点的方式**

1. 下载yml文件

   ```shell
   curl https://docs.projectcalico.org/manifests/calico.yaml -O
   ```

   目前已下载至本地[calico.yaml](calico.yaml)

2. 如果执行kubeadm init的时候的参数`--pod-network-cidr=192.168.0.0/16`，则跳过此步骤。如果设置的其他值，也不需要做调整，Calico执行配置的时候也会自动检测这个CIDR。但是如果是其他平台，则需要将calico.yaml文件中的CALICO_IPV4POOL_CIDR变量和--pod-network-cidr参数中设置的值相同。

3. 根据用户的需要，自行调整calico.yaml的其他配置。

4. 应用calico.yaml文件

   ```shell
   kubectl apply -f calico.yaml
   ```

**Kubernetes50个节点以上的方式**

1. 下载yml文件

   ```shell
   curl https://docs.projectcalico.org/manifests/calico-typha.yaml -o calico-typha.yaml
   ```

   目前已下载至本地[calico-typha.yaml](calico-typha.yaml)

2. 如果执行kubeadm init的时候的参数`--pod-network-cidr=192.168.0.0/16`，则跳过此步骤。如果设置的其他值，也不需要做调整，Calico执行配置的时候也会自动检测这个CIDR。但是如果是其他平台，则需要将calico.yaml文件中的CALICO_IPV4POOL_CIDR变量和--pod-network-cidr参数中设置的值相同。

3. 修改calico-typha.yaml文件，修改名称为calico-typha的Deployment，将副本数量replicas修改为所需要的值。

   ```shell
   apiVersion: apps/v1beta1
   kind: Deployment
   metadata:
     name: calico-typha
     ...
   spec:
     ...
     replicas: <number of replicas>
   ```

   我们建议每200个节点至少有一个副本，并且不超过20个副本。在生产中，我们建议至少使用三个副本，以减少滚动升级和故障的影响。副本的数量应始终小于节点的数量，否则滚动升级将暂停。此外，只有当Typha实例少于节点时，Typha才有助于扩展。

   > 警告：如果您设置typha_service_name并将typha部署副本计数设置为0，Felix将不会启动。

4. 根据用户的需要，自行调整calico.yaml的其他配置。

5. 应用calico.yaml文件

   ```shell
   kubectl apply -f calico-typha.yaml
   ```



### 网络插件Kube-router

**Github地址**

```shell
https://github.com/cloudnativelabs/kube-router/blob/master/docs/kubeadm.md
```



适用于Kubernetes v1.8以上的版本

- kube-router提供pod网络和网络策略

  ```shell
  KUBECONFIG=/etc/kubernetes/admin.conf kubectl apply -f https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/daemonset/kubeadm-kuberouter.yaml
  ```

  本地下载[kubeadm-kuberouter.yaml](kubeadm-kuberouter.yaml)

- kube-router提供服务代理、防火墙和pod网络

  ```shell
  KUBECONFIG=/etc/kubernetes/admin.conf kubectl apply -f https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/daemonset/kubeadm-kuberouter-all-features.yaml
  ```

- 由于kube-router提供了服务代理。运行下面的命令来删除kube-proxy和并清理iptables配置。

  ```shell
  KUBECONFIG=/etc/kubernetes/admin.conf kubectl -n kube-system delete ds kube-proxy
  docker run --privileged -v /lib/modules:/lib/modules --net=host k8s.gcr.io/kube-proxy-amd64:v1.15.1 kube-proxy --cleanup
  ```
  
  





## 服务发现

- [CoreDNS](https://coredns.io/) 是一种灵活的，可扩展的 DNS 服务器，可以 [安装](https://github.com/coredns/deployment/tree/master/kubernetes)为集群内的 Pod 提供 DNS 服务。



**地址**

```shell
https://github.com/coredns/deployment/tree/master/kubernetes

# 版本对应关系
https://github.com/coredns/deployment/blob/master/kubernetes/CoreDNS-k8s_version.md
```



Kubernetes Version v1.19  <--> CoreDNS version installed by kubeadm [v1.7.0](https://github.com/coredns/coredns/releases/tag/v1.7.0)

Kubernetes Version v1.20  <--> CoreDNS version installed by kubeadm [v1.7.0](https://github.com/coredns/coredns/releases/tag/v1.7.0)



### 替换Kube DNS为CoreDNS

在最佳情况下，替换Kube DNS为CoreDNS，所需的全部是以下命令：

```shell
$ ./deploy.sh | kubectl apply -f -
$ kubectl delete --namespace=kube-system deployment kube-dns
```

> 注意：您需要删除kube dns部署（如上所述），因为当CoreDNS和kube dns同时运行时，查询可能会随机命中其中一个。

对于非RBAC权限方式部署的情况，需要再apply之前编辑yaml文件。

1. 再Deployment中删除serviceAccountName:coredns行。

2. 删除ServiceAccount、ClusterRole和ClusterRoleBinding部分。

### 还原 Kube DNS

卸载，还原CoreDNS为Kebe-DNS

```shell
$ ./rollback.sh | kubectl apply -f -
$ kubectl delete --namespace=kube-system deployment coredns
```

> 注意：您需要删除CoreDNS部署（如上所述），因为当CoreDNS和kube dns同时运行时，查询可能会随机命中其中一个。



## 可视化管理

- [Dashboard](https://github.com/kubernetes/dashboard#kubernetes-dashboard) 是一个 Kubernetes 的 Web 控制台界面。



**地址**

```shell
https://github.com/kubernetes/dashboard#kubernetes-dashboard
```



[v2.3.1](https://github.com/kubernetes/dashboard/releases/tag/v2.3.1)

| Kubernetes version | 1.18 | 1.19 | 1.20 | 1.21 |
| ------------------ | ---- | ---- | ---- | ---- |
| Compatibility      | ?    | ?    | ✓    | ✓    |

- `✓` Fully supported version range.
- `?` Due to breaking changes between Kubernetes API versions, some features might not work correctly in the Dashboard.



[v2.0.5](https://github.com/kubernetes/dashboard/releases/tag/v2.0.5)

| Kubernetes version | 1.16 | 1.17 | 1.18 | 1.19 |
| ------------------ | ---- | ---- | ---- | ---- |
| Compatibility      | ?    | ?    | ?    | ✓    |

**Images**

- Kubernetes Dashboard

```
kubernetesui/dashboard:v2.0.5
```

- Metrics Scraper

```
kubernetesui/metrics-scraper:v1.0.6
```

- Installation

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.5/aio/deploy/recommended.yaml
```



[v2.0.4](https://github.com/kubernetes/dashboard/releases/tag/v2.0.4)

| Kubernetes version | 1.16 | 1.17 | 1.18 | 1.19 |
| ------------------ | ---- | ---- | ---- | ---- |
| Compatibility      | ?    | ?    | ?    | ✓    |





### 安装

要部署仪表板，请执行以下命令：

```shell
# 2.3.1
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.3.1/aio/deploy/recommended.yaml

# 2.0.5
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.5/aio/deploy/recommended.yaml
```



已下载本地[recommended-v2.0.5.yaml](recommended.yaml )

```shell
$ kubectl apply -f recommended-v2.0.5.yaml
```

已下载本地[recommended-v2.3.1.yaml](recommended-v2.3.1.yaml)

```shell
$ kubectl apply -f recommended-v2.0.5.yaml
```



或者，也可以使用Helm安装仪表板，如中所述https://artifacthub.io/packages/helm/k8s-dashboard/kubernetes-dashboard.



### 访问

要从本地工作站访问仪表板，必须创建到Kubernetes群集的安全通道。运行以下命令：

```shell
kubectl proxy
```

现在访问仪表板：

```shell
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
```

