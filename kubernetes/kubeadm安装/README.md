# 使用 kubeadm 创建集群

[TOC]

**版本说明**

该文档是基于官方的kubernetes1.19版本部署。kubernetes1.21版本的设置有些不同，但基于该文档依然可以部署。因此该文档适用于kubernetes1.19和kubernetes1.21版本。



kubernetes1.19.13版本

| 应用        | 版本    |
| ----------- | ------- |
| kubernetes  | 1.19.13 |
| docker-ce   | 20.10.7 |
| flannel     | v0.14.0 |
| Calico      | v3.19.1 |
| Kube-router | v1.3.0  |
| CoreDNS     | v1.7.0  |
| Dashboard   | v2.0.5  |



kubernetes1.21.3版本

| 应用        | 版本    |
| ----------- | ------- |
| kubernetes  | 1.21.3  |
| docker-ce   | 20.10.7 |
| flannel     | v0.14.0 |
| Calico      | v3.19.1 |
| Kube-router | v1.3.0  |
| CoreDNS     | v1.7.0  |
| Dashboard   | v2.3.1  |



**官方文档地址：**

```shell
https://v1-19.docs.kubernetes.io/zh/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
```

**最新版本地址：当前为1.21**

```shell
https://kubernetes.io/zh/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
```



##　准备开始

- 一台或多台运行兼容 deb/rpm 的 Linux 操作系统的计算机；例如：Ubuntu 或 CentOS。
- 每台机器 2 GB 以上的内存，内存不足时应用会受限制。
- 用作控制平面节点的计算机上至少有2个 CPU。
- 集群中所有计算机之间具有完全的网络连接。你可以使用公共网络或专用网络。



## 目标

- 安装单个控制平面的 Kubernetes 集群
- 在集群上安装 Pod 网络，以便你的 Pod 可以相互连通



## 操作指南

### 安装docker-ce

[安装docker-ce](docker-install.md)



### 安装Containerd

> k8s v1.20版本将不在支持docker，需要使用containerd。之前的版本可以安装docker。

[安装containerd](containerd-install.md)



### 安装环境准备

[环境准备](kubeadm-prepare.md)

- 环境准备

- 安装 runtime



### 在你的主机上安装安装 kubeadm

[安装kubeadm](kubeadm-install.md)

- 安装 kubeadm、kubelet 和 kubectl

- Cgroup 驱动程序
  - 配置Cgroup 驱动为systemd模式

- 启用 kubectl 自动补齐



### 部署Kubernetes集群

[kubeadm init部署集群](kubeadm-init.md)

- 部署集群

- 其他设置
  - 控制平面节点隔离

- 常用kubeadm命令



### 加入节点

**使用kubeadm init时，生成的kubeadm join命令附带的token加入集群。如果24小时过期，则使用下面的方法操作。**

[kubeadm join加入节点](kubeadm-join.md)



### 清理

[kubeadm clean集群](kubeadm-clean.md)

- 删除节点
- 清理控制平面



### 安装扩展（Addons）

[addons install安装扩展](addons-install.md)

- 安装 Pod 网络附加组件

  - 网络插件flannel安装

  - 网络插件Calico

  - 络插件Kube-router

- 服务发现
  - CoreDNS

- 可视化管理
  - Dashboard



### 为 Kubernetes 运行 etcd 集群

**kubeadm方式部署，会自动使用Pod的方式部署ETCD，因此这里可以不再额外的部署ETCD。**

如果为了持久化/灾备，则可以考虑使用下面的方式在宿主机上安装ETCD。

[为 Kubernetes 运行 etcd 集群](etcd-install.md)



### 对 kubeadm 进行故障排查

**官方地址**

```shell
https://v1-19.docs.kubernetes.io/zh/docs/setup/production-environment/tools/kubeadm/troubleshooting-kubeadm/
```



**总之**

> 学习测试环境用`kind`或`minikube`
>
> 生产环境用`kubeadm`



## 参考

- [kubernetes部署](https://www.cnblogs.com/jayce9102/p/10592913.html)

- [血泪史： k8s Initial timeout of 40s passed.](https://blog.csdn.net/weixin_40161254/article/details/112232302)
- [Kubernetes/K8S快速入门](https://www.psvmc.cn/article/2021-02-25-kubernetes-start-1.html)

- [Kubernetes/K8S快速入门之Kind](https://www.psvmc.cn/article/2021-02-27-kubernetes-start-3-kind.html)
- [Kubernetes/K8S快速入门之minikube](https://www.psvmc.cn/article/2021-02-26-kubernetes-start-2-minikube.html)

- [Kubernetes/K8S部署之kubeadm](https://www.psvmc.cn/article/2021-02-28-kubernetes-start-4-kubeadm.html)

- [使用kind来快速部署k8s环境](https://zhuanlan.zhihu.com/p/61492135)

