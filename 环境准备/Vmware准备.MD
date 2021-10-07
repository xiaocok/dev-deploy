## VMware环境准备和安装

[TOC]

### 安装虚拟机

1. 安装虚拟机VMware
2. 安装CentOS系统

### 设置网络

> 可以宿主机访问虚拟机

#### 添加网络适配器

1. 设置网络

   虚拟机CentOS->设置->硬件->网络适配器

   |    设备     |       摘要       |          说明          |
   | :---------: | :--------------: | :--------------------: |
   | 网络适配器  | 桥接模式（自动） | 连接物料网络，访问外网 |
   | 网络适配器2 |       NAT        |   宿主机与虚拟机通信   |

2. 安装网络工具

   ```shell
   # 安装网络
   yum install net-tools
   
   # 查看IP
   ifconfig
   
   # 查看ip地址
   ens37: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
           inet 192.168.195.130  netmask 255.255.255.0  broadcast 192.168.195.255
   ```

3. 宿主机连接虚拟机

   ```shell
   # ssh连接/可视化界面工具连接，ip地址为上面获取到的ip
   ssh root@192.168.195.130
   ```

#### 设置虚拟机为固定ip

1. 查看Vmwaer的网关信息

   Vmware -> 编辑 -> 虚拟网络编辑 -> 更改配置 -> 获取管理员权限

   选择Vmnet8(NAT模式的虚拟网络名称) -> NAT模式(与虚拟机共享主机的IP地址) -> NAT设置

   包含以下信息：

   网络：		vmnet8

   子网IP：	192.168.195.0

   子网掩码：255.255.255.0

   网关IP(G)：192.168.195.2

2. 查询虚拟机的IP和MAC地址

   CentOS虚拟机 -> **ip addr** 或者 **ifconfig**

   ```text
   ens37: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
       link/ether 00:0c:29:90:a8:9b brd ff:ff:ff:ff:ff:ff
       inet 192.168.195.130/24 brd 192.168.195.255 scope global ens37
          valid_lft forever preferred_lft forever
   ```

   包含以下信息：

   网络名称：ens37

   IP地址：	192.168.195.130

   MAC地址：00:0c:29:90:a8:9b

3. 设置网卡配置信息

   > 保存网卡配置信息，其中ifcfg-ens37是上面获取的网络名称

   vim /etc/sysconfig/network-scripts/ifcfg-ens37

   ```shell
   # 网卡设备名称(该项可以不设置)
   # NAME=ens37
   
   # 网卡设备名称, 必须和 NAME 值一样
   DEVICE=ens37
   # 网卡的引导协议：static=静态IP，dhcp=动态IP
   BOOTPROTO=static
   # 网卡的MAC地址
   HWADDR=00:0c:29:90:a8:9b
   # 设置固定IP的地址
   IPADDR=192.168.195.130
   # 网关地址
   GATEWAY=192.168.195.2
   # 网卡类型：Ethernets=以太网
   TYPE=Ethernets
   # 是否开机启动
   ONBOOT=yes
   ```

4. 重启虚拟机（reboot）验证IP是否固定不变。





### 设置共享文件夹

#### 准备、安装依赖

1. 安装GCC

   VMware Tools安装需要gcc

   ```shell
   # 查看是否安装
   gcc -v
   
   # 安装gcc
   yum install gcc
   ```

2. 安装perl

   VMware Tools安装需要perl

   ```shell
   # 查看是否安装
   perl -v
   
   # 官方地址 https://www.perl.org/
   # 官方源码下载地址 https://www.cpan.org/src/README.html
   # 安装
   wget http://www.cpan.org/src/5.0/perl-5.34.0.tar.gz
   tar -xzf perl-5.34.0.tar.gz
   cd perl-5.34.0
   ./Configure -des -Dprefix=/usr/local/perl
   make && make test && make install
   perl -v
   ```

3. 内核安装

   **直接安装kernel-headers**

   VMware Tools安装需要内核的kernel-headers文件，如果没有的话，则需要安装
   
   ```shell
   yum install kernel-headers
   ```

   如果安装kernel-headers的版本与当前的kernel版本不一致的情况，可以指定安装默认版本
   
   ```shell
   sudo yum install "kernel-devel-uname-r == $(uname -r)"
   ```
   
   
   
   **升级内核**
   
   但是，如果安装kernel-headers的版本与当前的kernel版本不一致的情况，则需要整体升级内核版本。
   
   ```shell
   yum install kernel kernel-devel kernel-headers
   ```
   
   **重启虚拟机**，选择安装的新的内核启动



​		**安装指定内核**

​		[CentOS安装指定内核](CentOS安装指定内核.MD)



#### 安装VMware Tools

1. 在主机上，从 Workstation Pro 菜单栏中选择**虚拟机** > **安装 VMware Tools**。

   如果安装了早期版本的 VMware Tools，则菜单项是 **更新 VMware Tools**。

2. 在虚拟机中，打开终端窗口。

3. 运行不带参数的 mount 命令，以确定 Linux 发行版是否已自动挂载 VMware Tools 虚拟 CD-ROM 映像。\

   如果已挂载 CD-ROM 设备，则将采用类似于以下输出的形式列出 CD-ROM 设备及其挂载点：

   ```shell
   /dev/cdrom on /mnt/cdrom type iso9660 (ro,nosuid,nodev)
   ```

4. 如果未挂载 VMware Tools 虚拟 CD-ROM 映像，请挂载 CD-ROM 驱动器。
   a. 如果挂载点目录尚不存在，请创建该目录。

   ```
   mkdir /mnt/cdrom
   ```

   某些 Linux 发行版使用不同的挂载点名称。例如，一些发行版的挂载点是 /media/VMware Tools，而不是 /mnt/cdrom。修改该命令以反映您的发行版所使用的约定。

   b. 挂载 CD-ROM 驱动器。

   ```
   mount /dev/cdrom /mnt/cdrom
   ```

   某些 Linux 发行版使用不同的设备名称或采取不同的方式组织 /dev 目录。如果 CD-ROM 驱动器不是 /dev/cdrom，或者如果 CD-ROM 的挂载点不是 /mnt/cdrom，请修改该命令以反映您的发行版所使用的约定。

5. 转到工作目录，例如 /tmp。

   `cd /tmp`

6. （可选）在安装 VMware Tools 之前，删除以前的任何 vmware-tools-distrib 目录。

   此目录的位置取决于在先前安装期间指定的位置。通常情况下，此目录位于 /tmp/vmware-tools-distrib 中

7. 列出挂载点目录的内容，并记下 VMware Tools tar 安装程序的文件名。

   ```
   ls mount-point
   ```

8. 解压缩安装程序。

   ```
   tar zxpf /mnt/cdrom/VMwareTools-x.x.x-yyyy.tar.gz
   ```

   值 x.x.x 是产品版本号，yyyy 是产品版本的内部版本号。

9. 如有必要，请卸载 CD-ROM 映像。

   ```
   umount /dev/cdrom 
   ```

   如果 Linux 发行版已自动挂载 CD-ROM，则不需要卸载该映像。

10. 运行安装程序并以 root 用户身份配置 VMware Tools。

    ```
    cd vmware-tools-distrib
    sudo ./vmware-install.pl
    ```

    通常，在安装程序文件结束运行后，将运行 vmware-config-tools.pl 配置文件。如果尝试在 RPM 安装的基础上执行 tar 安装，或者在 tar 安装的基础上执行 RPM 安装，安装程序将检测到先前的安装，并且必须转换安装程序数据库格式，然后才能继续。

11. 如果适合您的配置，请按照提示接受默认值。

12. 按照脚本结尾处的说明进行操作。

    根据使用的功能，这些说明可能包括重新启动 X 会话、重新启动网络连接、重新登录以及启动 VMware 用户进程。或者，也可以重新引导客户机操作系统以完成所有这些任务。



#### 配置共享文件夹

1. 设置共享文件夹

   虚拟机->设置->选项->共享文件夹

2. 设置自定义挂载目录

   安装VMware Tools后，共享文件夹默认放在`/mnt/hgfs/`目录下(/mnt/hgfs/xxx共享文件夹名称)，编辑`/etc/init.d/vmware-tools`

   ```shell
   # vmhgfs_mnt="/mnt/hgfs"
   vmhgfs_mnt="/www"
   ```

   把 vmhgfs_mnt 的值改想要设置的目录，**重启**后就更改了。



### 参考

- [在 Linux 虚拟机中手动安装 VMware Tools](https://docs.vmware.com/cn/VMware-Workstation-Pro/16.0/com.vmware.ws.using.doc/GUID-08BB9465-D40A-4E16-9E15-8C016CC8166F.html)
- [vmware设置共享文件夹的挂载目录（centos7）](https://www.cnblogs.com/moxiaoping/p/10235451.html)
- [在linux中安装perl详细步骤](https://blog.csdn.net/miachen520/article/details/91350156)
- [vmware + centos 7安装vmtools时提示The path "" is not a valid path to the xxx kernel header](https://blog.csdn.net/liu1340308350/article/details/80824696)
- [CentOS 7中安装指定的Kernel版本](https://blog.csdn.net/y1250056491/article/details/77856027)
- [Vmware虚拟机设置静态IP地址](https://www.cnblogs.com/chengssblog/p/6531964.html)

