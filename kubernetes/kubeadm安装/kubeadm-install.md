## 安装 kubeadm、kubelet 和 kubectl

官方文档地址：

```shell
# kubeadm安装文档地址

# 1.19
https://v1-19.docs.kubernetes.io/zh/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

# 最新版
https://kubernetes.io/zh/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

# kubeadm init命令行
https://v1-19.docs.kubernetes.io/zh/docs/reference/setup-tools/kubeadm/kubeadm-init/

# kube-apiserver命令行
https://v1-19.docs.kubernetes.io/zh/docs/reference/command-line-tools-reference/kube-apiserver/

# kubectl安装文档地址
https://v1-19.docs.kubernetes.io/zh/docs/tasks/tools/install-kubectl/

# kubectl命令行文档地址
https://v1-19.docs.kubernetes.io/zh/docs/reference/kubectl/kubectl/


# 安装指定版本的kubeadm、kubelet 和 kubectl
https://www.jianshu.com/p/75091ad364c1
```





- 配置yum源

  **官方源**
  
  ```shell
  # cat <<EOF > /etc/yum.repos.d/kubernetes.repo
  [kubernetes]
  name=Kubernetes
  baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
  enabled=1
  gpgcheck=1
  repo_gpgcheck=1
  gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
  EOF
  ```
  
  
  
  **阿里云加速源**
  
  不做校验安装，否则安装会提示错误
  
  ```shell
  # cat <<EOF > /etc/yum.repos.d/kubernetes.repo
  [kubernetes]
  name=Kubernetes
  baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
  enabled=1
  gpgcheck=0
  repo_gpgcheck=0
  gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
   http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
  EOF
  ```
  
  gpgcheck=0			  #不做校验
  
  repo_gpgcheck=0	#不做校验



- 查看kubelet kubeadm kubectl版本，你可以找到你所需要的版本

  ```shell
  # yum list kubelet kubeadm kubectl --showduplicates|sort -r
  
  # 精简方式
  # yum list kubeadm --showduplicates|sort -r
  
  kubectl.x86_64                       1.21.2-0                        kubernetes 
  kubectl.x86_64                       1.21.2-0                        @kubernetes
  kubectl.x86_64                       1.21.1-0                        kubernetes 
  kubectl.x86_64                       1.21.0-0                        kubernetes 
  kubectl.x86_64                       1.20.8-0                        kubernetes 
  kubectl.x86_64                       1.20.7-0                        kubernetes 
  kubectl.x86_64                       1.20.6-0                        kubernetes 
  kubectl.x86_64                       1.20.5-0                        kubernetes 
  kubectl.x86_64                       1.20.4-0                        kubernetes 
  kubectl.x86_64                       1.20.2-0                        kubernetes 
  kubectl.x86_64                       1.20.1-0                        kubernetes 
  kubectl.x86_64                       1.20.0-0                        kubernetes 
  kubectl.x86_64                       1.19.9-0                        kubernetes
  kubectl.x86_64                       1.19.8-0                        kubernetes
  kubectl.x86_64                       1.19.7-0                        kubernetes
  kubectl.x86_64                       1.19.6-0                        kubernetes
  kubectl.x86_64                       1.19.5-0                        kubernetes
  kubectl.x86_64                       1.19.4-0                        kubernetes
  kubectl.x86_64                       1.19.3-0                        kubernetes
  kubectl.x86_64                       1.19.2-0                        kubernetes
  kubectl.x86_64                       1.19.13-0                       kubernetes
  kubectl.x86_64                       1.19.12-0                       kubernetes
  kubectl.x86_64                       1.19.11-0                       kubernetes
  kubectl.x86_64                       1.19.1-0                        kubernetes
  kubectl.x86_64                       1.19.10-0                       kubernetes
  kubectl.x86_64                       1.19.0-0                        kubernetes 
  ```



- 指定版本安装kubelet kubeadm kubectl，这里我选择1.19.13版本进行安装

  确定安装版本，如果阿里加速镜像可以下载，则可以安装，否则不能安装

  ```shell
  docker pull registry.aliyuncs.com/google_containers/kube-apiserver:v1.19.13
  ```

  安装

  ```shell
  #1.19.13版本
  yum install -y kubelet-1.19.13 kubeadm-1.19.13 kubectl-1.19.13 --disableexcludes=kubernetes
  
  #1.21.3版本
  yum install -y kubelet-1.21.3 kubeadm-1.21.3 kubectl-1.21.3 --disableexcludes=kubernetes
  
  #启动kubelet
  systemctl enable --now kubelet
  ```

  

- 查看安装的版本

  ```shell
  # kubeadm version
  kubeadm version: &version.Info{Major:"1", Minor:"19", GitVersion:"v1.19.13", GitCommit:"53c7b65d4531a749cd3a7004c5212d23daa044a9", GitTreeState:"clean", BuildDate:"2021-07-15T20:57:06Z", GoVersion:"go1.15.14", Compiler:"gc", Platform:"linux/amd64"}
  
  # kubectl version --client
  Client Version: version.Info{Major:"1", Minor:"19", GitVersion:"v1.19.13", GitCommit:"53c7b65d4531a749cd3a7004c5212d23daa044a9", GitTreeState:"clean", BuildDate:"2021-07-15T20:58:11Z", GoVersion:"go1.15.14", Compiler:"gc", Platform:"linux/amd64"}
  
  # kubelet --version
  Kubernetes v1.19.13
  ```

  ```shell
  # kubeadm version
  kubeadm version: &version.Info{Major:"1", Minor:"21", GitVersion:"v1.21.3", GitCommit:"ca643a4d1f7bfe34773c74f79527be4afd95bf39", GitTreeState:"clean", BuildDate:"2021-07-15T21:03:28Z", GoVersion:"go1.16.6", Compiler:"gc", Platform:"linux/amd64"}
  
  # kubectl version --client
  Client Version: version.Info{Major:"1", Minor:"21", GitVersion:"v1.21.3", GitCommit:"ca643a4d1f7bfe34773c74f79527be4afd95bf39", GitTreeState:"clean", BuildDate:"2021-07-15T21:04:39Z", GoVersion:"go1.16.6", Compiler:"gc", Platform:"linux/amd64"}
  
  # kubelet --version
  Kubernetes v1.21.3
  ```

  

- kubelet配置文件路径

  - yum安装的配置文件路径

    ```shell
    /usr/lib/systemd/system/kubelet.service
    /usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf
    /var/lib/kubelet/kubeadm-flags.env
    ```

  - rpm包安装，则配置文件写入

    ```shell
    /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
    ```

  内容如下：

  ```shell
  [Service]
  Environment="KUBELET_KUBECONFIG_ARGS=--bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf
  --kubeconfig=/etc/kubernetes/kubelet.conf"
  Environment="KUBELET_CONFIG_ARGS=--config=/var/lib/kubelet/config.yaml"
  # 这是 "kubeadm init" 和 "kubeadm join" 运行时生成的文件，动态地填充 KUBELET_KUBEADM_ARGS 变量
  EnvironmentFile=-/var/lib/kubelet/kubeadm-flags.env
  # 这是一个文件，用户在不得已下可以将其用作替代 kubelet args。
  # 用户最好使用 .NodeRegistration.KubeletExtraArgs 对象在配置文件中替代。
  # KUBELET_EXTRA_ARGS 应该从此文件中获取。
  EnvironmentFile=-/etc/default/kubelet
  ExecStart=
  ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS
  ```

  [血泪史： k8s Initial timeout of 40s passed.](https://blog.csdn.net/weixin_40161254/article/details/112232302)
  



## Cgroup 驱动程序

**参考地址**

​	[Cgroup 驱动程序](https://v1-19.docs.kubernetes.io/zh/docs/setup/production-environment/container-runtimes/#cgroup-%E9%A9%B1%E5%8A%A8%E7%A8%8B%E5%BA%8F)

​	[在控制平面节点上配置 kubelet 使用的 cgroup 驱动程序](https://v1-19.docs.kubernetes.io/zh/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#configure-cgroup-driver-used-by-kubelet-on-master-node)



>  由于 kubeadm 把 kubelet 视为一个系统服务来管理，所以对基于 kubeadm 的安装， 我们推荐使用 `systemd` 驱动，不推荐 `cgroupfs` 驱动。



### 在控制平面节点上配置 kubelet 使用+的 cgroup 驱动程序

使用 docker 时，kubeadm 会自动为其检测 cgroup 驱动并在运行时对 `/var/lib/kubelet/kubeadm-flags.env` 文件进行配置。

如果您使用不同的 CRI，您需要使用 `cgroup-driver` 值修改 `/etc/default/kubelet` 文件（对于 CentOS、RHEL、Fedora，修改 **`/etc/sysconfig/kubelet`** 文件），像这样：

```bash
KUBELET_EXTRA_ARGS=--cgroup-driver=<value>

# 例如
KUBELET_EXTRA_ARGS=--cgroup-driver=cgroupfs
KUBELET_EXTRA_ARGS=--cgroup-driver=systemd
```

这个文件将由 `kubeadm init` 和 `kubeadm join` 使用以获取额外的用户自定义的 kubelet 参数。

请注意，您 **只** 需要在您的 cgroup 驱动程序不是 `cgroupfs` 时这么做，因为它已经是 kubelet 中的默认值。

需要重新启动 kubelet：

```bash
systemctl daemon-reload
systemctl restart kubelet
```



### 配置Cgroup 驱动为systemd模式

**docker和kubelet需要配置一致**

#### docker配置

- 修改配置文件

  ```shell
  vim /etc/docker/daemon.json
  
  # 设置为systemd模式
  {
      "exec-opts": ["native.cgroupdriver=systemd"],
  }
  ```

- 重启docker

  ```shell
  systemctl daemon-reload
  systemctl restart docker
  ```

#### kubelet配置

- 修改配置文件

  ```shell
  vim /etc/sysconfig/kubelet
  
  # 设置为systemd模式
  KUBELET_EXTRA_ARGS=--cgroup-driver=systemd
  ```

- 重启kubelet

  ```shell
  systemctl daemon-reload
  systemctl restart kubelet
  ```

  



## 启用 kubectl 自动补齐

```shell
yum install -y bash-completion
source <(kubectl completion bash)
echo "source <(kubectl completion bash)" >> ~/.bashrc
```



