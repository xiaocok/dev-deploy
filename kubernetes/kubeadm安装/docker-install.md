## 安装docker-ce

- 安装依赖

  ```shell
  yum install -y yum-utils device-mapper-persistent-data lvm2
  ```

- 添加yum源

  ```shell
  yum-config-manager \
      --add-repo \
      https://download.docker.com/linux/centos/docker-ce.repo
  ```

- 查看可安装版本

  ```shell
  # yum list docker-ce --showduplicates|sort -r
  
  docker-ce.x86_64            3:20.10.7-3.el7                     docker-ce-stable
  docker-ce.x86_64            3:20.10.0-3.el7                     docker-ce-stable
  docker-ce.x86_64            3:19.03.15-3.el7                    docker-ce-stable
  docker-ce.x86_64            3:19.03.0-3.el7                     docker-ce-stable
  docker-ce.x86_64            3:18.09.9-3.el7                     docker-ce-stable
  docker-ce.x86_64            3:18.09.0-3.el7                     docker-ce-stable
  docker-ce.x86_64            18.06.3.ce-3.el7                    docker-ce-stable
  docker-ce.x86_64            18.06.0.ce-3.el7                    docker-ce-stable
  docker-ce.x86_64            18.03.1.ce-1.el7.centos             docker-ce-stable
  docker-ce.x86_64            18.03.0.ce-1.el7.centos             docker-ce-stable
  docker-ce.x86_64            17.12.1.ce-1.el7.centos             docker-ce-stable
  docker-ce.x86_64            17.12.0.ce-1.el7.centos             docker-ce-stable
  docker-ce.x86_64            17.09.1.ce-1.el7.centos             docker-ce-stable
  docker-ce.x86_64            17.09.0.ce-1.el7.centos             docker-ce-stable
  docker-ce.x86_64            17.06.2.ce-1.el7.centos             docker-ce-stable
  docker-ce.x86_64            17.06.1.ce-1.el7.centos             docker-ce-stable
  docker-ce.x86_64            17.06.0.ce-1.el7.centos             docker-ce-stable
  docker-ce.x86_64            17.03.3.ce-1.el7                    docker-ce-stable
  docker-ce.x86_64            17.03.2.ce-1.el7.centos             docker-ce-stable
  docker-ce.x86_64            17.03.1.ce-1.el7.centos             docker-ce-stable
  docker-ce.x86_64            17.03.0.ce-1.el7.centos             docker-ce-stable
  ```

- 安装指定版本

  ```shell
  # 安装最新版
  yum install -y docker-ce
  
  # 安装指定版本
  yum install -y docker-ce-20.10.7
  
  # docker version
  Client: Docker Engine - Community
   Version:           20.10.7
  Server: Docker Engine - Community
   Engine:
    Version:          20.10.7
   containerd:
    Version:          1.4.8
   runc:
    Version:          1.0.0
   docker-init:
    Version:          0.19.0
  ```

  > 会附带安装containerd.io

- **创建docker目录**

  ```shell
  mkdir /etc/docker
  mkdir -p /etc/systemd/system/docker.service.d 
  ```

- 配置 Docker 守护程序

  设置镜像加速，使用 systemd 来管理容器的 cgroup。

  ```shell
  cat > /etc/docker/daemon.json <<EOF
  {
      "registry-mirrors": [
          "https://hub-mirror.c.163.com",
          "https://mirror.baidubce.com"
      ],
      "exec-opts": ["native.cgroupdriver=systemd"],
      "log-driver": "json-file",
          "log-opts": {
          "max-size": "100m"
      },
      "storage-driver": "overlay2"
  }
  EOF
  ```

  > **说明：**对于运行 Linux 内核版本 4.0 或更高版本，或使用 3.10.0-51 及更高版本的 RHEL 或 CentOS 的系统，`overlay2`是首选的存储驱动程序。

- 加载deamon重启docker

  ```shell
  systemctl daemon-reload
  systemctl restart docker
  systemctl enable docker
  ```

- 检查加速器是否生效

  执行 $ docker info，如果从结果中看到了如下内容，说明配置成功。

  ```shell
  Registry Mirrors:
    https://hub-mirror.c.163.com/
    https://mirror.baidubce.com/
  ```

  