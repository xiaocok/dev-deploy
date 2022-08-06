
# PHP扩展安装

## PECL安装
pecl地址：http://pecl.php.net/

### 安装最新版
```shell
pecl install xxx
```

例如：redis
```shell
pecl install redis
```

### 安装指定版本
例如：redis 4.3.0

地址从pecl官网去搜索
```shell
pecl install http://pecl.php.net/get/redis-4.3.0.tgz
```

例如：swoole 4.5.10
```
pecl install http://pecl.php.net/get/swoole-4.5.10.tgz
```
安装完成后提示
```
Build process completed successfully
Installing '/usr/lib64/php/modules/swoole.so'
```

PECL页面Homepage中有源码的地址：

https://github.com/swoole/swoole-src

github的地址有使用方法、和源码安装方式


### 添加扩展配置
修改php.ini配置文件，添加扩展
```
vim /etc/php.ini

extension=/usr/lib64/php/modules/swoole.so
```

> 通过 php -m 来查看是否成功加载了 swoole.so，如果没有可能是 php.ini 的路径不对。

> 可以使用 php --ini 来定位到 php.ini 的绝对路径，Loaded Configuration File 一项显示的是加载的 php.ini 文件，如果值为 none 证明根本没加载任何 php.ini 文件，需要自己创建。


重启php-fpm服务
```shell
systemctl restart php-fpm
```

### 查看已安装扩展信息
扩展的详情，保护扩展的版本
```shell
php --ri redis
```

```shell
# php --ri swoole
PHP Warning:  Module 'swoole' already loaded in Unknown on line 0

swoole

Swoole => enabled
Author => Swoole Team <team@swoole.com>
Version => 4.5.10
Built => Apr 22 2021 11:15:16
coroutine => enabled
epoll => enabled
eventfd => enabled
signalfd => enabled
cpu_affinity => enabled
spinlock => enabled
rwlock => enabled
openssl => OpenSSL 1.0.2k-fips  26 Jan 2017
pcre => enabled
zlib => 1.2.7
mutex_timedlock => enabled
pthread_barrier => enabled
futex => enabled
async_redis => enabled

Directive => Local Value => Master Value
swoole.enable_coroutine => On => On
swoole.enable_library => On => On
swoole.enable_preemptive_scheduler => Off => Off
swoole.display_errors => On => On
swoole.use_shortname => Off => Off
swoole.unixsock_buffer_size => 8388608 => 8388608
```

### 查看php的扩展
```shell
php -m
```

#### 参考
* [pecl 安装指定版本php扩展](https://blog.csdn.net/a791649892/article/details/99625521)



