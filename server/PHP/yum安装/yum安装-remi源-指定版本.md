# yum安装PHP

### 说明
> 默认的版本太低了，如果要安装更高版本，需要卸载旧版本

1. 生成最新缓存，提高搜索安装软件的速度
    ```
    yum makecache fast
    ```
   
2. 检查当前已安装的PHP包
    ```
    yum list installed | grep php
    ```

3. 如果有安装的PHP包，先删除他们。例如
    
    单个卸载
    ```
    yum remove php.x86_64 php-cli.x86_64 php-common.x86_64 php-gd.x86_64 php-ldap.x86_64 php-mbstring.x86_64 php-mcrypt.x86_64 php-mysql.x86_64 php-pdo.x86_64
    ```
    卸载全部
    ```
    yum remove php*
    ```
    
4. 检查可安装的PHP包
    ```
    yum list | grep php
    ```
    
5. 使用三方源安装指定版本
    > 默认的YUM源无法安装高版本的PHP，所以需要添加第三方的YUM源，此处用到webtatic。
    
    * 安装rpm源
    
        1.EPEL源
        ```
        安装 EPEL 源
        yum install epel-release

        安装 REMI 源
        yum install https://rpms.remirepo.net/enterprise/remi-release-7.rpm        
        ```

    * 卸载rpm源
    
        查询已安装的包
        ```
        rpm -q epel-release
        ```
        卸载已安装的包
        ```
        rpm -e epel-release-7-5.noarch
        ```
    * 报错，查看错误处理参考
        ```
        # yum search php
        Plugin "product-id" can't be imported
        Plugin "search-disabled-repos" can't be imported
        Plugin "subscription-manager" can't be imported
        Loaded plugins: fastestmirror
        ```
    
6. 安装
    * 安装 Yum 源管理工具：
        ```
        yum install yum-utils
        ```
    * 查看可安装的版本
        ```
        yum repolist all | grep php
        或者
        yum list | grep php
        或者
        yum list|grep php*.x86_64
        ```
    * 安装

        直接指定版本安装，例如7.4  
        
        参考示例：
        ```
        yum install \
        php74-php-bcmath.x86_64 \
        php74-php-devel.x86_64 \
        php74-php-embedded.x86_64 \
        php74-php-fpm.x86_64 \
        php74-php-gd.x86_64 \
        php74-php-ldap.x86_64 \
        php74-php-mbstring.x86_64 \
        php74-php-mysqlnd.x86_64 \
        php74-php-pdo.x86_64 \
        php74-php-pear.noarch \
        php74-php-pecl-crypto.x86_64 \
        php74-php-pecl-grpc.x86_64 \
        php74-php-pecl-memcache.x86_64 \
        php74-php-pecl-mongodb.x86_64 \
        php74-php-pecl-mysql.x86_64 \
        php74-php-pecl-ssh2.x86_64 \
        php74-php-pgsql.x86_64 \
        php74-php-phpiredis.x86_64 \
        php74-php-xml.x86_64 \
        php74-unit-php.x86_64
        ```
        
        安装
        ```
        #安装PHP/PHP-FPM
        yum -y install php74 php74-php-fpm
        
        # php 扩展1
        yum -y install php74-php-pdo php74-php-mbstring php74-php-gd php74-php-pecl-rdkafka php74-php-pecl-redis4 php74-php-bcmath php74-php-opcache php74-php-xml
        
        # php 扩展2
        yum -y install php74-php-pgsql php74-php-pecl-xhprof php74-php-pecl-swoole4 php74-php-pecl-protobuf
        ```
    
    * 查看可安装的PHP扩展
        ```
        #查看可安装的PHP看全部扩展
        yum search php74
        
        #查看PHP的MySQL扩展
        yum search php74 | grep mysql
        
        #查看已安装的MySQL扩展
        rpm -qa | grep php | grep mysql
        ```
    
7. 设置开机启动、运行服务
    ```
    #指定版本安装执行方式
    systemctl enable php74-php-fpm      #开机启动php-fpm服务
    systemctl start php74-php-fpm       #启动php-fpm服务
    ```
    查看9000端口是否正常启动
    ```
    netstat -tunlp | grep 9000
    ```
    
    * 其它命令
    ```
    重启
    systemctl restart php74-php-fpm

    启动
    systemctl start php74-php-fpm
    
    关闭
    systemctl stop php74-php-fpm
 
    检查状态
    systemctl status php74-php-fpm
    ```
    * 验证安装
    ```
    # php74-php -v
    PHP 7.4.16 (cli) (built: Mar  2 2021 10:35:17) ( NTS )
    Copyright (c) The PHP Group
    Zend Engine v3.4.0, Copyright (c) Zend Technologies
    ```
    
    * 查看启用的模块
    ```
    php74-php -m
    或者
    php74-php --modules
    ```
    
8. 安装路径确认
    * 查找RPM安装包，找到对应的php-fpm的名称
        ```
        rpm -qa | grep php
        ```
    * 根据名称，查看安装路径
        ```
        # rpm -ql php74-php-fpm-7.4.16-1.el7.remi.x86_64
        /etc/logrotate.d/php74-php-fpm
        /etc/opt/remi/php74/php-fpm.conf
        /etc/opt/remi/php74/php-fpm.d
        /etc/opt/remi/php74/php-fpm.d/www.conf
        /etc/opt/remi/php74/sysconfig/php-fpm
        /etc/systemd/system/php74-php-fpm.service.d
        /opt/remi/php74/root/usr/sbin/php-fpm
        /opt/remi/php74/root/usr/share/doc/php74-php-fpm-7.4.16
        /opt/remi/php74/root/usr/share/doc/php74-php-fpm-7.4.16/php-fpm.conf.default
        /opt/remi/php74/root/usr/share/doc/php74-php-fpm-7.4.16/www.conf.default
        /opt/remi/php74/root/usr/share/fpm
        /opt/remi/php74/root/usr/share/fpm/status.html
        /opt/remi/php74/root/usr/share/licenses/php74-php-fpm-7.4.16
        /opt/remi/php74/root/usr/share/licenses/php74-php-fpm-7.4.16/fpm_LICENSE
        /opt/remi/php74/root/usr/share/man/man8/php-fpm.8.gz
        /usr/lib/systemd/system/php74-php-fpm.service
        /var/opt/remi/php74/lib/php/opcache
        /var/opt/remi/php74/lib/php/session
        /var/opt/remi/php74/lib/php/wsdlcache
        /var/opt/remi/php74/log/php-fpm
        /var/opt/remi/php74/run/php-fpm
        ```
    * 查找php.ini位置
        ```
        # find /etc/opt/remi/php74 -name php.ini
        /etc/opt/remi/php74/php.ini
        ```
        
    * 位置整理
        ```
        # php.ini配置文件
        /etc/opt/remi/php74/php.ini
       
        # php-fpm.conf配置文件
        /etc/opt/remi/php74/php-fpm.conf
        /etc/opt/remi/php74/php-fpm.d
        
        # www.conf配置文件
        /etc/opt/remi/php74/php-fpm.d/www.conf
        
        # php-fpm执行程序
        /var/opt/remi/php74/run/php-fpm
        ```

9. 配置调整
    * 安全配置
    
        编辑/etc/opt/remi/php74/php.ini 替换换 ;cgi.fix_pathinfo=1 为 cgi.fix_pathinfo=0 快捷命令
        ```
        sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/opt/remi/php74/php.ini
        ```

    * 重启php74-php-fpm
        ```
        systemctl restart php74-php-fpm
        ```

10. 其他配置调整，参见[yum安装-remi源-推荐方式](yum安装-remi源.md)

#### 安装参考
* [通过yum安装PHP7](https://www.cnblogs.com/shifu204/p/7243576.html)
* [Centos下yum怎么安装php7](https://www.php.cn/php-weizijiaocheng-379696.html)
* [CENTOS 7 YUM 安装PHP7.4](https://blog.csdn.net/qq_35845964/article/details/110246464)
* [CentOS 7 yum 安装 PHP7.3 教程](https://blog.csdn.net/laohe08/article/details/93166590)
* [使用epel和remi第三方yum源，安装指定常用版本php](https://blog.csdn.net/lituxiu/article/details/90057277)

#### 报错参考
* [安装epel-release后报错，解决办法](http://blog.sina.com.cn/s/blog_e9dca8f00102y5zg.html)
* [Linux(Redhat 7.0) yum无法使用和subscription-manager提示](https://www.jianshu.com/p/7f22bb72a681)
* [安装错误提示：This system is not registered with an entitlement server. You can use subscription-manager to register.](https://blog.csdn.net/oraoharu/article/details/106808108)