



### kubeadm join phase

> 官方文档

https://kubernetes.io/zh-cn/docs/reference/setup-tools/kubeadm/kubeadm-join-phase/



恢复由于执行kubeadm reset -f引起的节点的etcd被删除集群的问题。执行到Unmounting /var/lib/kubelet时立即终止。

```bash
[root@master ~]# kubeadm reset -f
[reset] Reading configuration from the cluster...
[reset] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -oyaml'
W0818 07:23:33.903898    2798 reset.go:99] [reset] Unable to fetch the kubeadm-config ConfigMap from cluster: failed to get config map: Get "https://192.168.195.129:6443/api/v1/namespaces/kube-system/configmaps/kubeadm-config?timeout=10s": dial tcp 192.168.195.129:6443: connect: connection refused
[preflight] Running pre-flight checks
W0818 07:23:33.904515    2798 removeetcdmember.go:79] [reset] No kubeadm config, using etcd pod spec to get data directory
[reset] Stopping the kubelet service
[reset] Unmounting mounted directories in "/var/lib/kubelet"
```



#### 1、k8s的etcd关于member的常用命令

```bash
# 指定ETCD使用V3版本
export ETCDCTL_API=3

# 使用证书使用命令
etcdctl member list \
  --endpoints=https://192.168.195.129:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key

# 显示指定版本，并使用ETCD命令
ETCDCTL_API=3 etcdctl member list \
  --endpoints=https://192.168.195.129:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key

# 查询列表，并以表格显示
ETCDCTL_API=3 etcdctl \
  --endpoints=https://192.168.195.129:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  member list -w table

# 查看节点状态，并以表格显示。能显示主/从节点，信息更全面。
ETCDCTL_API=3 etcdctl \
  --endpoints=https://192.168.195.129:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key  \
  endpoint status --cluster -w table

# 加入节点
ETCDCTL_API=3 etcdctl \
  --endpoints=https://192.168.195.129:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key  \
  member add node1 https://192.168.195.130:2380

# 常用的member命令参考
etcdctl member remove <member-id>
etcdctl member add <member-name> <member-url>
etcdctl member list
```

**cert/key证书可以使用健康检查证书healthcheck。官方kubeadm join phase control-plane-join etcd就是使用的healthcheck证书。**

  --cert=/etc/kubernetes/pki/etcd/healthcheck-client.crt
  --key=/etc/kubernetes/pki/etcd/healthcheck-client.key

实际上使用这些命令并未将etcd加入集群。加入的etcd的member没有start。而启动的etcd的pod提升id不在集群内。应该使kubeadm join实现一些额外的操作。



#### 2、kubeadm join phase命令

**实际使用该方法恢复了集群**

```bash
kubeadm join phase control-plane-join etcd [flags]

kubeadm join phase control-plane-join etcd --control-plane --node-name=node1
```

1. 挂载kubelet：/var/lib/kubelet

   ```bash
   mount -a
   ```

2. 启动containerd

   ```bash
   systemctl start containerd
   ```

3. 删除etcd的存量数据

   ```bash
   mv /var/lib/etcd/member /var/lib/etcd/member-back
   ```

4. 加入etcd

   ```bash
   kubeadm join phase control-plane-join etcd --control-plane --node-name=node1
   或者，可以不指定节点名称
   kubeadm join phase control-plane-join etcd --control-plane
   ```

   





