## CentOS安装指定内核

### 查看系统版本

1. 查看当前系统内核版本

   ```shell
   # uname -a
   Linux localhost.localdomain 3.10.0-1160.el7.x86_64 #1 SMP Mon Oct 19 16:18:59 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux
   
   # uname -r
   3.10.0-1160.el7.x86_64
   ```

2. Linux查看版本当前操作系统发行版信息

   ```shell
   cat /etc/redhat-release
   ```

### 直接安装当前内核的headers/delvel

```shell
sudo yum install "kernel-devel-uname-r == $(uname -r)"
```



### 安装指定内核

1. 下载内核

   下载地址

   到http://ftp.scientificlinux.org/linux/scientific/7.0/x86_64/updates/security/下载对应的内核源码包，网页全部加载完比较慢，需要等一段时间。

   ```shell
   # 版本选择
   http://ftp.scientificlinux.org/linux/scientific/
   
   # 例如CentOS7.0
   http://ftp.scientificlinux.org/linux/scientific/7.0/x86_64/updates/security/
   
   # 例如CentOS7.9
   http://ftp.scientificlinux.org/linux/scientific/7.9/x86_64/updates/security/
   
   # 示例
   # kernel-3.10.0-1062.el7.x86_64
   http://ftp.scientificlinux.org/linux/scientific/7.0/x86_64/updates/security/kernel-3.10.0-1062.el7.x86_64.rpm
   
   # kernel-headers-3.10.0-1160.42.2.el7.x86_64
   http://ftp.scientificlinux.org/linux/scientific/7.9/x86_64/updates/security/kernel-headers-3.10.0-1160.42.2.el7.x86_64.rpm
   ```

   下载

   ```shell
   wget http://ftp.scientificlinux.org/linux/scientific/7.0/x86_64/updates/security/kernel-3.10.0-693.el7.x86_64.rpm
   
   wget http://ftp.scientificlinux.org/linux/scientific/7.0/x86_64/updates/security/kernel-3.10.0-1062.el7.x86_64.rpm
   ```

2. 安装下载的内核

   ```shell
   yum install kernel-3.10.0-693.el7.x86_64.rpm -y
   ```

3. 升级yum安装内核源码时报错了，提示需要dracut的版本>=033-502

   解决方法如下：

   ```shell
   #切换到yum源存放目录
   cd /etc/yum.repos.d/
   
   #下载centos7最新源
   wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
   
   yum clean all    	#清理缓存
   yum makecache    	#生成缓存
   yum proides dracut	#查看软件包所有版本
   yum install dracut-033-360.nfs.2.x86_64 -y    #找到合适的版本下载即可
   ```

4. 查看并启用新内核

   ```shell
   # grep ^menuentry /etc/grub2.cfg | cut -f 2 -d \'
   CentOS Linux (3.10.0-1160.42.2.el7.x86_64) 7 (Core)
   CentOS Linux (3.10.0-693.el7.x86_64) 7 (Core)
   CentOS Linux (0-rescue-8a32361b93304457832fb1cb3a5386c6) 7 (Core)
   ```

5. 设置默认启动内核

   看到新安装的内核版本在第一排，表示0行，执行以下命令grub配置文件默认启动内核

   ```shell
   grub2-set-default 0
   ```

6. 重启系统检查内核版本已经升级成功









#### 参考

- [Centos7.0升级至指定内核版本](http://www.linxiongxiong.com/archives/370)

- [CentOS 7中安装指定的Kernel版本](https://blog.csdn.net/y1250056491/article/details/77856027)