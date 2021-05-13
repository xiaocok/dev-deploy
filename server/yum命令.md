
# yum命令

### 查询包的全部可安装版本
```shell
yum --showduplicates list nginx | expand

可安装的软件包
nginx.x86_64                       1.8.0-1.el6.ngx                         nginx
nginx.x86_64                       1.8.1-1.el6.ngx                         nginx
nginx.x86_64                       1.10.0-1.el6.ngx                        nginx
nginx.x86_64                       1.10.1-1.el6.ngx                        nginx
nginx.x86_64                       1.10.2-1.el6.ngx                        nginx
nginx.x86_64                       1.10.3-1.el6.ngx                        nginx
nginx.x86_64                       1.12.0-1.el6.ngx                        nginx
nginx.x86_64                       1.12.1-1.el6.ngx                        nginx
nginx.x86_64                       1.12.2-1.el6.ngx                        nginx
nginx.x86_64                       1.14.0-1.el6.ngx                        nginx
nginx.x86_64                       1.14.1-1.el6.ngx                        nginx
nginx.x86_64                       1.14.2-1.el6.ngx                        nginx
nginx.x86_64                       1.16.0-1.el6.ngx                        nginx
```

### 安装指定版本 1.14.2-1.el6.ngx
```shell
yum install nginx-1.14.2-1.el6.ngx
```


### 参考
* [yum 安装指定版本 nginx](http://lukachen.com/archives/307/)