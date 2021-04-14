
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


## Composer 加速

1. 配置全局加速
    * 国内通用加速
        ```
        $ composer config -g repo.packagist composer https://packagist.phpcomposer.com
        ```
    
    * laravel加速
        ```
        $ composer config -g repo.packagist composer https://packagist.laravel-china.org
        ```
    
    * 阿里云加速
        ```
        $ composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
        ```
    
2. 配置当前项目加速
    * 例如：阿里云
        ```
        $ composer config repo.packagist composer https://mirrors.aliyun.com/composer/
        ```

3. 取消加速
    ```
    $ composer config -g --unset https://mirrors.aliyun.com/composer/
    ```

4. 查看Composer全局设置
    ```
    $ composer config -gl
    ```

5. 执行安装
    ```
    composer install
    ```

6. 加速地址

       阿里云（推荐）
           镜像类型：全量镜像
           更新时间：1 分钟
           镜像地址：https://mirrors.aliyun.com/composer/
           官方地址：https://mirrors.aliyun.com/composer/index
           镜像说明：阿里云 CDN 加速，更新速度快，推荐使用
           
       安畅网络镜像
           镜像类型：全量镜像
           更新时间：1 分钟
           镜像地址：https://php.cnpkg.org
           官方地址：https://php.cnpkg.org/
           镜像说明：此 Composer 镜像由安畅网络赞助，目前支持元数据、下载包全量代理。
       
       交通大学镜像
           镜像类型：非全量镜像
           镜像地址：https://packagist.mirrors.sjtug.sjtu.edu.c/
           官方地址：https://mirrors.sjtug.sjtu.edu.cn/packagis
           镜像说明：上海交通大学提供的 composer 镜像，稳定、快速、现代的镜像服务，推荐使用。

7. 异常情况
    
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
* 加速
    * [Composer 国内加速](https://www.imooc.com/article/details/id/293297)
    * [Composer 设置国内镜像加速命令](https://blog.csdn.net/qq_39479575/article/details/78515219)
    * [Laravel 安装和开发环境：Composer 国内加速镜像](https://learnku.com/laravel/wikis/25522)
    * [php项目构建速度优化 composer加速](https://blog.csdn.net/t_1007/article/details/86702737)
* 错误
    * [compoesr install报错](https://www.cnblogs.com/trblog/p/13260089.html)
