### 加入节点

**使用kubeadm init时，生成的kubeadm join命令附带的token加入集群。如果24小时过期，则使用下面的方法操作。**

```shell
kubeadm token create --print-join-command  #重新生成加入的令牌命令
```



节点是你的工作负载（容器和 Pod 等）运行的地方。要将新节点添加到集群，请对每台计算机执行以下操作：

```shell
kubeadm join --token <token> <control-plane-host>:<control-plane-port> --discovery-token-ca-cert-hash sha256:<hash>
```

如果没有令牌，可以通过在控制平面节点上运行以下命令来获取令牌：

```shell
kubeadm token list
```

默认情况下，令牌会在24小时后过期。如果要在当前令牌过期后将节点加入集群， 则可以通过在控制平面节点上运行以下命令来创建新令牌：

```shell
kubeadm token create
```

输出类似于以下内容：

```console
5didvk.d09sbcov8ph2amjw
```

如果你没有 `--discovery-token-ca-cert-hash` 的值，则可以通过在控制平面节点上执行以下命令链来获取它：

```bash
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | \
   openssl dgst -sha256 -hex | sed 's/^.* //'
```

输出类似于以下内容：

```console
8cb2de97839780a412b93877f8507ad6c94f73add17d5d7058e91741c9d5ec78
```





### 加入集群失败：

#### 错误1：没有ca证书

One or more conditions for hosting a new control plane instance is not satisfied.

**failure loading certificate for CA: couldn't load the certificate file /etc/kubernetes/pki/ca.crt: open /etc/kubernetes/pki/ca.crt: no such file or directory**

Please ensure that:
* The cluster has a stable controlPlaneEndpoint address.
* The certificates that must be shared among control plane instances are provided.

**解决办法：**

```shell
# 创建文件夹
sudo mkdir -p /etc/kubernetes/pki
sudo mkdir -p /etc/kubernetes/pki/etcd

# 拷贝证书
sudo scp -rp "root@192.168.195.129:/etc/kubernetes/pki/ca.*" /etc/kubernetes/pki/
sudo scp -rp "root@192.168.195.129:/etc/kubernetes/pki/sa.*" /etc/kubernetes/pki
sudo scp -rp "root@192.168.195.129:/etc/kubernetes/pki/front-proxy-ca.*" /etc/kubernetes/pki/
sudo scp -rp "root@192.168.195.129:/etc/kubernetes/pki/etcd/ca.*" /etc/kubernetes/pki/etcd/
sudo scp -rp "root@192.168.195.129:/etc/kubernetes/admin.conf" /etc/kubernetes/

# 加入集群
sudo kubeadm join 192.168.33.100:6443 \
	--token m30ouq.zlhsacvdp1mwrjy4 \
    --discovery-token-ca-cert-hash \
    sha256:cba621c95049b4fe5d4623c6e979e430bf569c22bfd3d079a98e8ea26483a685 \
    --control-plane \
    --v=5
```

加入成功后，提示一下信息，执行响应的命令即可

```shell
To start administering your cluster from this node, you need to run the following as a regular user:

	mkdir -p $HOME/.kube
	sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
	sudo chown $(id -u):$(id -g) $HOME/.kube/config

Run 'kubectl get nodes' to see this node join the cluster.
```



### 参考

- [k8s搭建v1.18.3高可用集群时添加master节点报错：failure loading certificate for CA: couldn‘t load the certificate fil](https://blog.csdn.net/weixin_43815140/article/details/108648756)
