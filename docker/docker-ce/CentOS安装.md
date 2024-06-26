# Docker CE安装

官方文档：https://docs.docker.com/install/linux/docker-ce/centos/

---
## 准备

替换yum源

```shell
yum install wget

mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.back

wget -O /etc/yum.repos.d/CentOS-7.repo http://mirrors.aliyun.com/repo/Centos-7.repo
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
或者
curl -o /etc/yum.repos.d/CentOS-7.repo http://mirrors.aliyun.com/repo/Centos-7.repo
curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo

sed -i 's#keepcache=0#keepcache=1#g' /etc/yum.conf
yum clean all && yum makecache
yum repolist

#安装依赖
yum -y install yum-utils createrepo plugin-priorities
```



安装防火墙(开发环境可以不用安装)
1. 安装systemctl：
```shell
yum install iptables-services
```
注意不是yum install iptables

2. 设置开机启动：
```shell
systemctl enable iptables.service
```

3. 常用命令
```shell
systemctl stop iptables
systemctl start iptables
systemctl restart iptables
systemctl reload iptables
```


## 一、yum安装
### 1、卸载旧版本
```shell script
$ sudo yum remove docker \
    docker-client \
    docker-client-latest \
    docker-common \
    docker-latest \
    docker-latest-logrotate \
    docker-logrotate \
    docker-engine
```

### 2、删除所有旧的数据
```shell script
$ sudo rm -rf /var/lib/docker
```

### 3、安装所需对应的依赖包
* yum-utils提供了yum-config-manager 效用，并device-mapper-persistent-data和lvm2由需要 devicemapper存储驱动程序
```shell script
$ sudo yum install -y yum-utils \
    device-mapper-persistent-data \
    lvm2
```

### 4、添加yum源
```shell script
$ sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
    
# 阿里云
$ sudo yum-config-manager \
    --add-repo \
    https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
```

### 5、可选：参数设置
* 夜间更新源nightly（可选）
```shell script
$ sudo yum-config-manager --enable docker-ce-nightly   #开启夜间更新源，每天晚上更新存储库
$ sudo yum-config-manager --disable docker-ce-nightly  #关闭
```

* edge和test的版本库repository（可选）：Docker 17.06开始，稳定版本也被推到edge和test版本库了
```shell script
$ sudo yum-config-manager --enable docker-ce-edge     #启用edge版本库
$ sudo yum-config-manager --disable docker-ce-edge    #关闭

$ sudo yum-config-manager --enable docker-ce-test     #启用test版本库
$ sudo yum-config-manager --disable docker-ce-test    #关闭
```

### 6、安装最新版本
```shell script
$ sudo yum -y install docker-ce docker-ce-cli containerd.io
```

### 7、安装历史版本
```shell script
#列出历史版本
$ sudo yum list docker-ce --showduplicates | sort –r

#安装指定版本
$ sudo yum install docker-ce-<VERSION_STRING> docker-ce-cli-<VERSION_STRING> containerd.io
```

### 8、启动服务
```shell script
$ sudo systemctl start docker
```

### 9、设置服务开机自启
```shell script
$ sudo systemctl enable docker
```


---
## 二、rpm包安装
官网rpm包下载地址:
https://download.docker.com/linux/centos/7/x86_64/stable/Packages/



https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-24.0.6-1.el7.x86_64.rpm

https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-cli-24.0.6-1.el7.x86_64.rpm

https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.6.24-3.1.el7.x86_64.rpm


## 参考
* [重启防火墙（iptables)命令#service iptable restart失效](https://www.cnblogs.com/manmanchanglu/p/12167510.html)