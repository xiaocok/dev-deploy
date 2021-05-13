
# Windows 10 安装子系统 Ubuntu


### 重启子系统Ubuntu

WSL 子系统是基于 LxssManager 服务运行的。
只需要将 LxssManager 重启即可。
```shell
net stop LxssManager
net start LxssManager
```
**注意：必须在管理员权限下运行。**

### 参考
Windows10子系统
* [Windows 10开启Linux子系统](https://www.jianshu.com/p/6af3846dbe68)
* [适用于 Linux 的 Windows 子系统安装指南 (Windows 10)](https://docs.microsoft.com/zh-cn/windows/wsl/install-win10)

Windows的终端
* [安装和设置 Windows 终端](https://docs.microsoft.com/zh-cn/windows/terminal/get-started)
* [安装各种版本的 PowerShell](https://docs.microsoft.com/zh-cn/powershell/scripting/install/installing-powershell?view=powershell-7.1)

操作
* [如何重启 Windows 10 子系统（WSL) ubuntu](https://blog.csdn.net/weixin_37251044/article/details/114108199)