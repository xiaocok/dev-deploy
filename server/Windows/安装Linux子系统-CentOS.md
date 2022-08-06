
## 前提条件：
1. 打开WSL

    1.1 方式一：使用管理员权限打开 powershell,执行

		Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
    1.2方式二：控制面板->程序->启用或关闭windows功能->找到适用于Linux的Windows子系统勾选，确定后需要重启电脑生效。

## 方式一：微软商店安装centos
微软商店的centos均需要收费，放弃。

## 方式二：Github开源工具WSL-Distribution-Switcher
注意：该方式前提是系统内需要有一个linux子系统，可以在微软商店安装免费的ubuntu。

原因：WSL-Distribution-Switcher需要依赖一个ubuntu，现在不装，后期也需要安装。

参考网址：[GitHub - RoliSoft/WSL-Distribution-Switcher: Scripts to replace the distribution behind Windows Subsystem for Linux with any other Linux distribution published on Docker Hub.](https://github.com/RoliSoft/WSL-Distribution-Switcher)

> 出现下载镜像报错：cmd切换为管理员模式

1. 下载WSL-Distribution-Switcher

    下载地址：https://github.com/RoliSoft/WSL-Distribution-Switcher/archive/master.zip


2. 安装python3，如果有跳过这步

    下载地址：Welcome to Python.org
    
    下载windows的exe执行文件直接安装即可


3. 通过WSL-Distribution-Switcher下载Centos7
    
    3.1在WSL-Distribution-Switcher的目录下使用cmd，可以到dockerhub上去查看具体的tag,也可以在WSL-Distribution-Switcher目录下打开Redme.md查看tag。

    3.2.获取centos镜像和依赖镜像

    获取镜像-> 
    ```python get-source.py centos:latest``` 或者 ```python get-source.py centos:centos7```

    获取依赖镜像->比如 
    ```python get-prebuilt.py centos:latest``` 或者 ```python get-prebuilt.py centos:centos7```

    3.3安装

    > 注意：部分镜像采用了SquashFS 格式，需要安装一个python插件。指令：pip3 install PySquashfsImage
    
    ```shell
    python install.py centos:centos7
    ```

    报错：暂未解决。。。。

    The Linux subsystem is not installed. Please go through the standard installation procedure first.



## 方式三：LxRunOffline工具
1. 安装LxRunOffline

    方法一：下载 https://github.com/DDoSolitary/LxRunOffline/releases 解压

    方法二：powershell中运行(会安装到C:\tools下)：choco install lxrunoffline

2. 下载系统镜像

    例如：rootfs_centos_centos7.tar.xz

    方式一：https://github.com/RoliSoft/WSL-Distribution-Switcher第二步的工具可以下载

    方式二：https://docs.microsoft.com/en-us/windows/wsl/install-manual （微软来源）

3. 操作目录为D:\WSL作为安装使用目录，可任意更换

    准备工作：

    1.将LxRunOffline.exe和rootfs_centos_centos7.tar.xz复制到D:\WSL目录下。

    2.如果想随处使用LxRunOffline.exe，请加入系统环境变量，则不需要拷贝LxRunOffline.exe。

4. 安装镜像
    ```text
    #其中 -d 后面是要安装到的目录，-f 是前面下载的镜像， -n 用来指定名称。
    D:\WSL>D:\WSL\LxRunOffline.exe install -n centos7 -d D:\WSL\centos7 -f D:\WSL\rootfs_centos_centos7.tar.xz
    ```
 
5. 查看镜像
    ```shell
    D:\WSL>LxRunOffline.exe list
    Ubuntu
    centos7
    ```

6. 运行镜像
    ```shell
    D:\WSL>LxRunOffline.exe run -n centos7
    ```

7. 卸载镜像
    ```shell
    D:\WSL\LxRunOffline.exe uninstall -n centos7
    ```
8. 创建快捷方式(一般命令行创建失败，则使用管理员模式打开cmd)
    ```shell
    D:\WSL>lxrunoffline s -n centos7 -f 'C:\Users\lingyang\Desktop\centos7.lnk'
    ```



### 参考
* [windows10下安装子系统linux（centos）](https://www.cnblogs.com/luckyang/p/14085095.html)