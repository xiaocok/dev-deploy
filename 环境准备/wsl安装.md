# wsl安装

[安装问题](https://learn.microsoft.com/zh-cn/windows/wsl/troubleshooting#installation-issues)

## 一、安装准备

### 1、更改存储位置

#### 1). 设置存储位置

> 适用于 Linux 的 Windows 子系统只能在系统驱动器（通常是 `C:` 驱动器）中运行。 

**在 Windows 10 上打开**“设置”->“系统”->“存储”->“更多存储设置: 更改新内容的保存位置”

**在 Windows 11 上打开**“设置”->“系统”->“存储”->“高级存储设置”->“新内容的保存位置”

![image-20230218124945860](wsl安装.assets\image-20230218124945860.png)



#### 2). 存在的问题

个别系统，特别是**将磁盘分区类型由MBR转GPT**的磁盘，如果切换到一个之前由MBR转换为GPT的盘，可能安装会提示一下错误

```powershell
WslRegisterDistribution failed with error: 0x80071772
```

[WslRegisterDistribution failed with error: 0x80071772]([WslRegisterDistribution failed with error: 0x80071772_不喝咖啡c的博客-CSDN博客_wslregisterdistribution failed with error: 0x80071](https://blog.csdn.net/old__tree/article/details/125990962))

**解决办法：**删除Ubuntu，然后将安装路径切换回C盘，在重新安装Ubuntu。



#### 3). wsl安装到非C盘解决方案

[wsl安装到非C盘解决方案](https://zhuanlan.zhihu.com/p/419242528)

1. 官方下载安装包
2. 提取安装包
3. 直接运行

[WSL2 修改安装目录](https://www.bilibili.com/read/cv17865605)

1. 导出保存之其他路径
2. 重新导入



### 2、启用wsl

> 启用“适用于 Linux 的 Windows 子系统”可选组件

打开“控制面板”->“程序和功能”->“打开或关闭 Windows 功能”-> 选中“适用于 Linux 的 Windows 子系统”



## 二、安装wsl

[使用 WSL 在 Windows 上安装 Linux](https://learn.microsoft.com/zh-cn/windows/wsl/install)



### 1、自动安装/命令行安装

[1.windows11开启wsl2并安装Ubuntu 20.04](https://blog.csdn.net/guo_ridgepole/article/details/121031044)

[WSL 的基本命令](https://learn.microsoft.com/zh-cn/windows/wsl/basic-commands#set-wsl-version-to-1-or-2)

> 由于网络问题，一般会报错 ”无法解析服务器的名称或地址“ , 可以选择**手动安装**

命令行安装时使用的github的子系统，不是微软商店提供的子系统

```powershell
# 默认情况下，安装的 Linux 分发版为 Ubuntu。 可以使用 -d 标志进行更改。
wsl --install

# 若要更改安装的发行版， 将 <Distribution Name> 替换为要安装的发行版的名称。
wsl --install -d <Distribution Name>

# 若要查看可通过在线商店下载的可用 Linux 发行版列表
wsl --list --online 或 wsl -l -o

# 若要在初始安装后安装其他 Linux 发行版。
wsl --install -d <Distribution Name>
```

选项包括：

- `--distribution`：指定要安装的 Linux 发行版。 可以通过运行 `wsl --list --online` 来查找可用的发行版。
- `--no-launch`：安装 Linux 发行版，但不自动启动它。
- `--web-download`：通过联机渠道安装，而不是使用 Microsoft Store 安装。

未安装 WSL 时，选项包括：

- `--inbox`：使用 Windows 组件（而不是 Microsoft Store）安装 WSL。 *（WSL 更新将通过 Windows 更新接收，而不是通过 Microsoft Store 中推送的可用更新来接收）。*
- `--enable-wsl1`：在安装 Microsoft Store 版本的 WSL 的过程中也启用“适用于 Linux 的 Windows 子系统”可选组件，从而启用 WSL 1。
- `--no-distribution`：安装 WSL 时不安装发行版。



#### 1). 问题

[【解决】正在连接 raw.githubusercontent.com 失败：拒绝连接](https://blog.csdn.net/weixin_40973138/article/details/106081946)

[github图床链接打开提示raw.githubusercontent.com无法访问解决](https://www.jianshu.com/p/51decd726dd1)

执行命令提示无法解析域名，通过https://site.ip138.com/或者代理工具修改host之后，提示超时

```text
无法从'https://raw.githubusercontent.com/microsoft/WSL/master/distributions/DistributionInfo.json'提取列表分发。无法与服务器建立连接
Error code: Wsl/WININET_E_CANNOT_CONNECT
```





### 2、手动安装

[旧版 WSL 的手动安装步骤](https://learn.microsoft.com/zh-cn/windows/wsl/install-manual)

[1.windows11开启wsl2并安装Ubuntu 20.04]([1.windows11开启wsl2并安装Ubuntu 20.04_西瓜那么甜的博客-CSDN博客_开启wsl2](https://blog.csdn.net/guo_ridgepole/article/details/121031044))

[window10安装debian linux子系统](https://www.cnblogs.com/imust2008/p/16962908.html)



#### 1). 查看当前版本，设置为版本2

```powershell
wsl --status
wsl --set-default-version 2
```



#### 2). 升级内核

> 将wsl1升级到wsl2

**命令升级内核**

```pow
wsl --update
```

**或者手动安装**

[WslRegisterDistribution failed with error_ 0x8007019e、0x800701bc、0x80370102](https://blog.csdn.net/qq_37085158/article/details/125172803)

> wsl1升级到之后，内核没有升级

[wsl_update_x64.msi](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi)



#### 2). 微软商店安装

**设置代理**

> 微软商店在国内无法下载资源，需要设置代理

[微软商店/微软商店代理](https://www.bilibili.com/video/av211506056/?vd_source=0eafa421f09152cc7c6c879ff42465e3)



#### 3). 下载离线安装

> 如果设置了代理，依然从微软商店无法下载，则使用下载离线安装

https://learn.microsoft.com/zh-cn/windows/wsl/install-manual

```powershell
# 下载
curl.exe -L -o ubuntu-2004.appx https://aka.ms/wslubuntu2004

# 安装
Add-AppxPackage .\app_name.appx
```



## 三、配置

### 1、通用配置

[设置 WSL 开发环境](https://learn.microsoft.com/zh-cn/windows/wsl/setup/environment)

### 2、高级配置

[WSL 中的高级设置配置](https://learn.microsoft.com/zh-cn/windows/wsl/wsl-config)



- **[.wslconfig](https://learn.microsoft.com/zh-cn/windows/wsl/wsl-config#wslconfig)** ，用于在 WSL 2 上运行的所有已安装分发版 **全局** 配置设置。
- **[wsl.conf](https://learn.microsoft.com/zh-cn/windows/wsl/wsl-config#wslconf)** 为 WSL 1 或 WSL 2 上运行的 Linux 发行版配置 **每个分发** 版的设置。



#### wsl.conf

- 以 `/etc` unix 文件的形式存储在分发目录中。
- 用于按分布配置设置。 此文件中配置的设置将仅应用于包含存储此文件的目录的特定 Linux 分发版。
- 可用于版本、WSL 1 或 WSL 2 运行的分发版。
- 若要访问已安装的发行版的 `/etc` 目录，请使用发行版的命令行和 `cd /` 访问根目录，然后使用 `ls` 列出文件或使用 `explorer.exe .` 在 Windows 文件资源管理器中查看。 目录路径应如下所示： `/etc/wsl.conf`



```ini
# Automatically mount Windows drive when the distribution is launched
[automount]

# Set to true will automount fixed drives (C:/ or D:/) with DrvFs under the root directory set above. Set to false means drives won't be mounted automatically, but need to be mounted manually or with fstab.
enabled = true

# Sets the directory where fixed drives will be automatically mounted. This example changes the mount location, so your C-drive would be /c, rather than the default /mnt/c. 
root = /

# DrvFs-specific options can be specified.  
options = "metadata,uid=1003,gid=1003,umask=077,fmask=11,case=off"

# Sets the `/etc/fstab` file to be processed when a WSL distribution is launched.
mountFsTab = true

# Network host settings that enable the DNS server used by WSL 2. This example changes the hostname, sets generateHosts to false, preventing WSL from the default behavior of auto-generating /etc/hosts, and sets generateResolvConf to false, preventing WSL from auto-generating /etc/resolv.conf, so that you can create your own (ie. nameserver 1.1.1.1).
[network]
hostname = DemoHost
generateHosts = false
generateResolvConf = false

# Set whether WSL supports interop process like launching Windows apps and adding path variables. Setting these to false will block the launch of Windows processes and block adding $PATH environment variables.
[interop]
enabled = false
appendWindowsPath = false

# Set the user when launching a distribution with WSL.
[user]
default = DemoUser

# Set a command to run when a new WSL instance launches. This example starts the Docker container service.
[boot]
command = service docker start
```





#### .wslconfig

- 存储在目录中 `%UserProfile%` 。
- 用于跨作为 WSL 2 版本运行的所有已安装 Linux 分发版全局配置设置。
- **只能用于 WSL 2 运行的分发**版。 作为 WSL 1 运行的分发版不会受到此配置的影响，因为它们未作为虚拟机运行。
- 要访问 `%UserProfile%` 目录，请在 PowerShell 中使用 `cd ~` 访问主目录（通常是用户配置文件 `C:\Users\<UserName>`），或者可以打开 Windows 文件资源管理器并在地址栏中输入 `%UserProfile%`。 目录路径应如下所示： `C:\Users\<UserName>\.wslconfig`



```ini
# Settings apply across all Linux distros running on WSL 2
[wsl2]

# Limits VM memory to use no more than 4 GB, this can be set as whole numbers using GB or MB
memory=4GB 

# Sets the VM to use two virtual processors
processors=2

# Specify a custom Linux kernel to use with your installed distros. The default kernel used can be found at https://github.com/microsoft/WSL2-Linux-Kernel
kernel=C:\\temp\\myCustomKernel

# Sets additional kernel parameters, in this case enabling older Linux base images such as Centos 6
kernelCommandLine = vsyscall=emulate

# Sets amount of swap storage space to 8GB, default is 25% of available RAM
swap=8GB

# Sets swapfile path location, default is %USERPROFILE%\AppData\Local\Temp\swap.vhdx
swapfile=C:\\temp\\wsl-swap.vhdx

# Disable page reporting so WSL retains all allocated memory claimed from Windows and releases none back when free
pageReporting=false

# Turn off default connection to bind WSL 2 localhost to Windows localhost
localhostforwarding=true

# Disables nested virtualization
nestedVirtualization=false

# Turns on output console showing contents of dmesg when opening a WSL 2 distro for debugging
debugConsole=true
```



#### *限制CPU和内存

```powershell
[wsl2]
# 内存限制
memory=8GB
# cpu限制
processors=24
```





## 四、使用

### *1. 登录

使用PowerShell登录

```powershell
# 如果指定了默认的发行版为Ubuntu，也指定了默认用户，则使用默认用户登录
ubuntu

# 默认发行版的特定用户的身份运行
wsl -u root
wsl -u <Username>
wsl --user <Username>

# 指定发行版和指定用户
# 通过 PowerShell 运行特定的 Linux 发行版
wsl --distribution <Distribution Name> --user <User Name>
wsl -d Ubuntu -u root
wsl -d Debian -u root
```



### *2. 更改默认发行版和默认用户

或许Ubuntu不是默认的发行版

```powershell
# 查看子系统
wsl -l

# 设置默认 Linux 发行版
wsl --set-default Ubuntu
```



默认是非root用户登录

```powershell
<DistributionName> config --default-user <Username>
Ubuntu config --default-user root

# 会将 Ubuntu 发行版的默认用户更改为“johndoe”用户
ubuntu config --default-user johndoe
```

可以改为使用 `/etc/wsl.conf` 文件来更改导入的发行版的默认用户。 请参阅[高级设置配置](https://learn.microsoft.com/zh-cn/windows/wsl/wsl-config#user-settings)文档中的“自动装载”选项。



### 3. 其他命令

[WSL 的基本命令](https://learn.microsoft.com/zh-cn/windows/wsl/basic-commands#set-wsl-version-to-1-or-2)

```powershell
# 列出已安装的 Linux 发行版
wsl -l
wsl --list --verbose
wsl -l -v
--all（列出所有发行版）
--running（仅列出当前正在运行的发行版）
--quiet（仅显示发行版名称）
 
# 列出可用的 Linux 发行版
# 查看可通过在线商店获得的 Linux 发行版列表
wsl --list --online
wsl -l -o
 
# 将 WSL 版本设置为 1 或 2
wsl --set-version <distribution name> <versionNumber>
wsl --set-version 2

# 设置默认 WSL 版本
wsl --set-default-version <Version>
wsl --set-default-version 2

# 设置默认 Linux 发行版
wsl --set-default <Distribution Name>

# 检查 WSL 状态
wsl --status
 
# 更新 WSL
# 将wsl1升级到wsl2
wsl --update
```



### *4. 停止发行版、关闭wsl

**终止、停止发行版**

若要终止指定的发行版或阻止其运行，请将 `<Distribution Name>` 替换为目标发行版的名称。

```powershell
wsl --terminate <Distribution Name>
wsl --terminate ubuntu
```



**关闭wsl**

> 关闭全部的发行版

```powershell
wsl --shutdown
```

立即终止所有正在运行的发行版和 WSL 2 轻量级实用工具虚拟机。 在需要重启 WSL 2 虚拟机环境的情形下，例如[更改内存使用限制](https://learn.microsoft.com/zh-cn/windows/wsl/disk-space)或更改 [.wslconfig 文件](https://learn.microsoft.com/zh-cn/windows/wsl/manage#)，可能必须使用此命令。



### 5. 注销或卸载 Linux 发行版

尽管可以通过 Microsoft Store 安装 Linux 发行版，但无法通过 Store 将其卸载。

```powershell
# 注销并卸载 WSL 发行版
wsl --unregister <DistributionName>
```



### 6. 导入和导出发行版

```powershell
wsl --export <Distribution Name> <FileName>
wsl --import <Distribution Name> <InstallLocation> <FileName>
```

将指定 tar 文件导入和导出为新的发行版。 在标准输入中，文件名可以是 -。 选项包括：

- `--vhd`：指定导入/导出发行版应为 .vhdx 文件，而不是 tar 文件
- `--version`：（仅导入）指定将发行版导入为 WSL 1 还是 WSL 2 发行版



**就地导入发行版**

```powershell
wsl --import-in-place <Distribution Name> <FileName>
```

将指定的 .vhdx 文件导入为新的发行版。 虚拟硬盘必须采用 ext4 文件系统类型格式。



### 7. 文件存储

```powershell
\\wsl$\<DistroName>\home\<UserName>\Project
```



### 8. 装载、卸载磁盘或设备

#### 8.1 装载磁盘或设备

```powershell
wsl --mount <DiskPath>
```

通过将 `<DiskPath>` 替换为物理磁盘所在的目录\文件路径，在所有 WSL2 发行版中附加和装载该磁盘。 请参阅[在 WSL 2 中装载 Linux 磁盘](https://learn.microsoft.com/zh-cn/windows/wsl/wsl2-mount-disk)。 选项包括：

- `--vhd`：指定 `<Disk>` 引用虚拟硬盘。
- `--name`：使用装入点的自定义名称装载磁盘
- `--bare`：将磁盘附加到 WSL2，但不进行装载。
- `--type <Filesystem>`：装载磁盘时使用的文件系统类型默认为 ext4（如果未指定）。 此命令也可输入为：`wsl --mount -t <Filesystem>`。可以使用 `blkid <BlockDevice>` 命令检测文件系统类型，例如：`blkid <dev/sdb1>`。
- `--partition <Partition Number>`：要装载的分区的索引号默认为整个磁盘（如果未指定）。
- `--options <MountOptions>`：装载磁盘时，可以包括一些特定于文件系统的选项。 例如，`wsl --mount -o "data-ordered"` 或 `wsl --mount -o "data=writeback` 之类的 [ext4 装载选项](https://www.kernel.org/doc/Documentation/filesystems/ext4.txt)。 但是，目前仅支持特定于文件系统的选项。 不支持通用选项，例如 `ro`、`rw` 或 `noatime`。



#### 8.2 卸载磁盘

```powershell
wsl --unmount <DiskPath>
```

卸载磁盘路径中给定的磁盘，如果未提供磁盘路径，则此命令将卸载并分离所有已装载的磁盘。



#### *8.3 文件夹挂载

> 理论上是文件夹映射

wsl默认安装后，会将Windows系统的磁盘挂载到Ubuntu中`/mnt`目录下

```powershell
root@:/mnt# ll /mnt
total 4
drwxrwxrwx  1 root root 4096 Feb 25 17:14 c/
drwxrwxrwx  1 root root 4096 Feb 25 17:14 d/
drwxrwxrwt  2 root root   60 Feb 25 17:27 wsl/
drwxrwxrwt  7 root root  300 Feb 25 17:28 wslg/
```

挂载windows的文件夹之linux中

```powershell
# ln -s /mnt/d/WWW /home/vagrant/WWW

root@DESKTOP-BKUTSQL:/home/vagrant# ll /home/vagrant/
total 4
lrwxrwxrwx 1 root    root      10 Feb 25 12:50 WWW -> /mnt/d/WWW/
```



### 9. 调整分区大小

[调整区分大小写](https://learn.microsoft.com/zh-cn/windows/wsl/case-sensitivity)



### 10. 如何管理 WSL 磁盘空间

[如何管理 WSL 磁盘空间](https://learn.microsoft.com/zh-cn/windows/wsl/disk-space)



### *11. 设置固定IP

[1.windows11开启wsl2并安装Ubuntu 20.04](https://blog.csdn.net/guo_ridgepole/article/details/121031044)

https://github.com/microsoft/WSL/issues/4210#issuecomment-648570493

```text
我给你一个新的想法: 与其改变 IP，不如增加一个指定的 IP。
在 Windows 10中，使用管理员权限运行 CMD 或 Powershell，然后执行以下两个命令:

在 Ubuntu 中添加一个 IP 地址，192.168.50.16，命名为 eth0:1
wsl -d Ubuntu -u root ip addr add 192.168.50.16/24 broadcast 192.168.50.255 dev eth0 label eth0:1

在 Win10中添加 IP 地址，192.168.50.88
netsh interface ip add address "vEthernet (WSL)" 192.168.50.88 255.255.255.0

在未来，当你访问 Ubuntu 时，你将使用192.168.50.16，当你访问 Win10时，你将使用192.168.50.88。
可以将上面两行命令保存为。然后把它放到启动区域，让它每次都自动执行。
```



**具体操作方式：**

创建一个bat脚本文件

作用为在Windows中添加一个ip为 172.23.220.20 的地址，然后在Ubuntu中添加一个ip为 172.23.220.10 的地址

```powershell
netsh interface ip add address "vEthernet (WSL)" 172.23.220.20 255.255.255.0
wsl -d Ubuntu-20.04 -u root ip addr add 172.23.220.10/24 broadcast 172.23.220.255 dev eth0 label eth0:1
```


然后开机后以管理员方式运行该脚本即可

同样，也可以使用该方式解决wsl2中子系统无法自启服务的问题，如想要启动mysql，只需要增加一行命令即可

```powershell
wsl -d Ubuntu-20.04 -u root service mysql start
```



## 五、开发环境搭建

[设置 WSL 开发环境](https://learn.microsoft.com/zh-cn/windows/wsl/setup/environment?source=recommendations)



### *1、文件拷贝

打开WSL子系统的shell终端,输入:

```powershell
explorer.exe .
```



### *2、程序文件夹挂载

```powershell
ln -s /mnt/d/WWW /home/vagrant/WWW
```



### 3、安装VSCode

[设置 WSL 开发环境](https://learn.microsoft.com/zh-cn/windows/wsl/setup/environment?source=recommendations)

[开始通过适用于 Linux 的 Windows 子系统使用 Visual Studio Code](https://learn.microsoft.com/zh-cn/windows/wsl/tutorials/wsl-vscode)

#### 1. 更新 Linux 发行版

> Windows 不会自动更新或升级 Linux 分发版

某些 WSL Linux 发行版缺少启动 VS Code 服务器所需的库。 可以使用其他库的包管理器将其他库添加到 Linux 发行版中。

```powershell
sudo apt-get update && sudo apt upgrade
sudo apt-get install wget ca-certificates
```



若要从 WSL 发行版打开项目，请打开发行版的命令行并输入：`code .`

![使用 VS Code 远程服务器打开 WSL 项目](./wsl安装.assets/wsl-open-vs-code.gif)



### 4、安装Docker

[WSL 2 上的 Docker 远程容器入门](https://learn.microsoft.com/zh-cn/windows/wsl/tutorials/wsl-containers)

确保在“设置”>“常规”中选中“使用基于 WSL 2 的引擎”。

![image-20230218143228319](wsl安装.assets\image-20230218143228319.png)

通过转到“设置”>“资源”>“WSL 集成”，从要启用 Docker 集成的已安装 WSL 2 发行版中进行选择。

![image-20230218143352242](wsl安装.assets\image-20230218143352242.png)



## 参考

- [适用于 Linux 的 Windows 子系统文档](https://learn.microsoft.com/zh-cn/windows/wsl/)
- [使用 WSL 在 Windows 上安装 Linux](https://learn.microsoft.com/zh-cn/windows/wsl/install)
- [WslRegisterDistribution failed with error_ 0x8007019e、0x800701bc、0x80370102](https://blog.csdn.net/qq_37085158/article/details/125172803)
- [排查适用于 Linux 的 Windows 子系统问题](https://learn.microsoft.com/zh-cn/windows/wsl/troubleshooting?source=recommendations)
- [有关适用于 Linux 的 Windows 子系统的常见问题解答](https://learn.microsoft.com/zh-cn/windows/wsl/faq?source=recommendations)
- [设置 WSL 开发环境](https://learn.microsoft.com/zh-cn/windows/wsl/setup/environment?source=recommendations)
- [开始通过适用于 Linux 的 Windows 子系统使用 Visual Studio Code](https://learn.microsoft.com/zh-cn/windows/wsl/tutorials/wsl-vscode)
- [wsl2使用vscode无法写入文件permission denied解决方法](https://www.pudn.com/news/626636114f8811599eac6d90.html)
- [解决WSL2中Vmmem内存占用过大问题](https://blog.csdn.net/bwibt/article/details/125620882)