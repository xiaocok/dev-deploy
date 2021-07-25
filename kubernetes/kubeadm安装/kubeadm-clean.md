## 清理

如果你在集群中使用了一次性服务器进行测试，则可以关闭这些服务器，而无需进一步清理。你可以使用 `kubectl config delete-cluster` 删除对集群的本地引用。

但是，如果要更干净地取消配置群集， 则应首先[清空节点](https://v1-19.docs.kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#drain)并确保该节点为空， 然后取消配置该节点。

### 删除节点

使用适当的凭证与控制平面节点通信，运行：

```bash
kubectl drain <node name> --delete-local-data --force --ignore-daemonsets
```

在删除节点之前，请重置 `kubeadm` 安装的状态：

```bash
kubeadm reset
```

重置过程不会重置或清除 iptables 规则或 IPVS 表。如果你希望重置 iptables，则必须手动进行：

```bash
iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X
```

如果要重置 IPVS 表，则必须运行以下命令：

```bash
ipvsadm -C
```

现在删除节点：

```bash
kubectl delete node <node name>
```

如果你想重新开始，只需运行 `kubeadm init` 或 `kubeadm join` 并加上适当的参数。

### 清理控制平面

你可以在控制平面主机上使用 `kubeadm reset` 来触发尽力而为的清理。

有关此子命令及其选项的更多信息，请参见[`kubeadm reset`](https://v1-19.docs.kubernetes.io/zh/docs/reference/setup-tools/kubeadm/kubeadm-reset/)参考文档。

