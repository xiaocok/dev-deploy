
# PHP Composer

官方网址：https://getcomposer.org/

## Composer 安装
* 命令行安装
    ```
    # 下载
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    
    # 校验文件
    php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    
    # 执行安装
    php composer-setup.php
    
    # 删除安装文件
    php -r "unlink('composer-setup.php');"
    ```
    
    注意：执行安装参数
    ```
    # 指定执行程序文件名
    php composer-setup.php --filename=composer
    
    # 指定执行程序文件名、安装路径
    php composer-setup.php --install-dir=/usr/local/bin/ --filename=composer
  
    示例：
    php composer-setup.php --install-dir=bin --filename=composer
    ```

* 下载安装
    ```
    # 下载安装脚本
    # composer-setup.php下载地址：https://getcomposer.org/download/
    php composer-setup.php --install-dir=bin --filename=composer
    
    # 直接下载
    https://getcomposer.org/download/2.0.12/composer.phar
    mv composer.phar /usr/local/bin/composer
    ```

## 使用composer的一些异常情况
1. 调试信息
    ```
    composer 命令后面加上 -vvv （是 3 个 v）可以打印出调错信息，命令如下：
    
    $ composer -vvv create-project laravel/laravel blog
    $ composer -vvv require psr/log
    ```

2. 已存在 composer.lock 文件，先删除，再运行 composer install 重新生成。
    ```
    原因：composer.lock 缓存了之前的配置信息，从而导致新的镜像配置无效。
    ```

3. 使用 laravel new 命令创建工程， 这个命令会从 这里 下一个 zip 包，里面自带了 composer.lock，和上面原因一样，也无法使用镜像加速，解决方法：
    ```
    方法一 （推荐）：
    不使用 laravel new，直接用 composer create-project laravel/laravel xxx 新建工程。
    
    方法二：
    运行 laravel new xxx，当看见屏幕出现 - Installing doctrine/inflector 时，Ctrl + C 终止命令，cd xxx 进入，删除 composer.lock，再运行 composer install。
    ```

4. 缓存多久更新一次
    ```
    0 时 - 早上 7 时，这个时间段考虑使用人数不会太频繁，间隔为 15 分钟
    其余时间，间隔为 5 分钟
    正常更新速度可在 1 分内完成 ，但更新太快，会降低 CDN 命中率，如果总有新文件让 CDN 去缓存，反而拖慢了速度，所以故意加了些延迟。我们每次采集中还会删减掉数千个僵尸包，以加快传输速度。
    ```

5. 其他请参见下面参考

#### 参考
* [compoesr install报错](https://www.cnblogs.com/trblog/p/13260089.html)
