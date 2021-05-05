

### 教程
进入容器内部

Git Bash，前面需要加winpty
```shell
winpty docker exec -it xxx bash
```

Windows PowerShell, 直接操作
```shell
docker exec -it xxx bash
```

### 参考
* [关于docker使用run命令加上参数-it时出现the input device is not a TTY.  If you are using mintty, try prefixing the command with 'winpty'](https://blog.csdn.net/NerverSimply/article/details/79738505)
* [the input device is not a TTY. If you are using mintty, try prefixing the command with 'winpty'](https://blog.csdn.net/zzq060143/article/details/91050203)
