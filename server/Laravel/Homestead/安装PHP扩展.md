
# Homestead安装PHP扩展

> Laravel官方Vagrant镜像Homestead，默认没有安装php的Mongodb扩展，以下是php7.1手动安装mongodb扩展的教程。可以按照这个教程，写自动化的脚本哦。

### 第一步：pecl update通道升级
```shell
sudo pecl channel-update
```

### 第二步：创建openssl的快捷方式，不然会报错
```shell
sudo ln -s /usr/lib/x86_64-linux-gnu/libssl.so  /usr/lib
```

### 第三步：使用pecl自动安装mongodb扩展
```shell
sudo pecl install mongodb
```
低版本的php，使用的是 sudo pecl install mongo命令安装扩展


### 第四步：修改php.ini的配置文件，添加扩展

这里要注意Homestead有两个位置的php.ini要修改，一个是/ect/php/7.1/fpm/php.ini，一个是/etc/php/7.1/cli/php.ini，

使用sudo vim php.ini命令

在这两个php.ini 文件里添加 extension=mongodb.so

如果是低版本的php，添加extension=mongo.so。


### 第五步：重新启动php7.1-fpm
```shell
sudo service php7.1-fpm restart
```

### 第六步：查看php的扩展
```shell
php -m
```

如果有mongodb的扩展，则表明我们安装成功啦。


#### 参考
* [Laravel官方Vagrant镜像Homestead手动安装php7.1的MongoDB扩展的方法](http://www.jicker.cn/5631.html)