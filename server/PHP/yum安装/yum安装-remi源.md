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
    
        用yum-config-manager启用指定remi的php7.4仓库
        
        ```
        #如果想选择其它版本的话，把remi-php74改为remi-php71、remi-php70等，要看/etc/yum.repos.d/里的remi仓库对应上
        yum-config-manager --enable remi-php74
        
        #直接安装，即为7.4版本
        yum install php php-cli php-fpm php-mysqlnd php-zip php-devel php-gd php-mcrypt php-mbstring php-curl php-xml php-pear php-bcmath php-json php-redis
        ```
        
        全部安装
        ```
        php-bcmath php-curl php-ctype php-dom php-gd php-iconv php-json php-mbstring php-mysqlnd php-openssl php-pdo php-pdo_mysql php-pdo_sqlite php-phar php-posix php-redis php-sockets php-sodium php-sysvshm php-sysvmsg php-sysvsem php-zip php-zlib php-xml php-xmlreader php-pcntl php-opcache
        ```
      
    * 查看可安装的PHP扩展
        ```
        #查看可安装的PHP看全部扩展
        yum search php
        
        #查看PHP的MySQL扩展
        yum search php | grep mysql
        
        #查看已安装的MySQL扩展
        rpm -qa | grep php | grep mysql
        ```
    
7. 设置开机启动、运行服务
    ```
    systemctl enable php-fpm    #开机启动php-fpm服务
    systemctl start php-fpm     #启动php-fpm服务
    ```
    查看9000端口是否正常启动
    ```
    netstat -tunlp | grep 9000
    ```
    
    * 其它命令
    ```
    重启
    systemctl restart php-fpm

    启动
    systemctl start php-fpm
    
    关闭
    systemctl stop php-fpm
 
    检查状态
    systemctl status php-fpm
    ```
    * 验证安装
    ```
    # php -v
    PHP 7.4.16 (cli) (built: Mar  2 2021 10:35:17) ( NTS )
    Copyright (c) The PHP Group
    Zend Engine v3.4.0, Copyright (c) Zend Technologies
    ```
    
    * 查看启用的模块
    ```
    php -m
    或者
    php --modules
    ```
    
8. 安装路径确认
    * 查找RPM安装包，找到对应的php-fpm的名称
        ```
        rpm -qa | grep php
        ```
    * 根据名称，查看安装路径
        
        whereis php<br/>
        或者<br/>
        rpm -ql php-fpm-7.4.16-1.el7.remi.x86_64
    
        ```
        # rpm -ql php-fpm-7.4.16-1.el7.remi.x86_64
        /etc/logrotate.d/php-fpm
        /etc/php-fpm.conf
        /etc/php-fpm.d
        /etc/php-fpm.d/www.conf
        /etc/sysconfig/php-fpm
        /etc/systemd/system/php-fpm.service.d
        /run/php-fpm
        /usr/lib/systemd/system/php-fpm.service
        /usr/sbin/php-fpm
        /usr/share/doc/php-fpm-7.4.16
        /usr/share/doc/php-fpm-7.4.16/README
        /usr/share/doc/php-fpm-7.4.16/httpd-php.conf
        /usr/share/doc/php-fpm-7.4.16/nginx-fpm.conf
        /usr/share/doc/php-fpm-7.4.16/nginx-php.conf
        /usr/share/doc/php-fpm-7.4.16/php-fpm.conf.default
        /usr/share/doc/php-fpm-7.4.16/www.conf.default
        /usr/share/fpm
        /usr/share/fpm/status.html
        /usr/share/licenses/php-fpm-7.4.16
        /usr/share/licenses/php-fpm-7.4.16/fpm_LICENSE
        /usr/share/man/man8/php-fpm.8.gz
        /var/lib/php/opcache
        /var/lib/php/session
        /var/lib/php/wsdlcache
        /var/log/php-fpm
        ```
          
    * 位置整理
        ```
        # php.ini配置文件
        /etc/php.ini
       
        # php-fpm.conf配置文件
        /etc/php-fpm.conf
        /etc/php-fpm.d
        
        # www.conf配置文件
        /etc/php-fpm.d/www.conf
        
        # 备份的默认配置
        /usr/share/doc/php-fpm-7.4.16/httpd-php.conf
        /usr/share/doc/php-fpm-7.4.16/nginx-fpm.conf
        /usr/share/doc/php-fpm-7.4.16/nginx-php.conf
        /usr/share/doc/php-fpm-7.4.16/php-fpm.conf.default
        /usr/share/doc/php-fpm-7.4.16/www.conf.default
        
        # php-fpm执行程序
        /usr/sbin/php-fpm
        /run/php-fpm
        
        # 日志
        /var/log/php-fpm
        ```

9. 配置调整
    * 安全优化
        1. pathinfo配置
            ```
            # 编辑/etc/php.ini 替换换 ;cgi.fix_pathinfo=1 为 cgi.fix_pathinfo=0 快捷命令
            sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php.ini
            
            # 说明
            # cgi.fix_pathinfo默认被注释并且值为1。
            # 当文件不存在时，阻止Nginx将请求发送到后端的PHP-FPM模块。
            # 从而避免恶意脚本注入的攻击，所以此项应该去掉注释并设置为0。
            ```

        2. 避免日志暴露
            ```
            #避免PHP信息暴露在http头中
            expose_php = Off
    
            #避免暴露php调用mysql的错误信息
            display_errors = Off
    
            #在关闭display_errors后开启PHP错误日志（路径在php-fpm.conf中配置）
            log_errors = On
            ```

    * 配置优化
        ```
        #设置PHP的时区
        date.timezone = PRC

        #开启opcache
        [opcache]
        ; Determines if Zend OPCache is enabled
        opcache.enable=1

        #设置PHP脚本允许访问的目录（需要根据实际情况配置）
        ;open_basedir = /usr/share/nginx/html;
        ```

    * 重启php-fpm
        ```
        systemctl restart php-fpm
        ```

10. 其他配置

    * 修改php-fpm的用户

        * 查看nginx的用户，默认安装后为nginx
        
        vim /etc/php-fpm.d/www.conf
        ```
        # 如果是apache服务器，则使用默认配置
        user = apache
        group = apache
        
        # 如果是nginx，则使用下面的配置，用户通过/etc/nginx/nginx.conf查看user nginx;
        user = nginx
        group = nginx
        ```
        
        重启php-fpm
            
            systemctl restart php-fpm

    * nginx配置调整
    
        vim /etc/nginx/nginx.conf
        
        ```
        server {
            # 添加默认index.php文件支持
            location / {
                root   html;
                index  index.html index.htm index.php;
            }
            
            # 添加对php文件的解析支持，修改脚本入库文件路径
            location ~ \.php$ {
                root           html;
                fastcgi_pass   127.0.0.1:9000;
                fastcgi_index  index.php;
                #fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
                fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
                include        fastcgi_params;
            }
        }
        ```
        
        参考配置
        ```
        server {
            listen 80;
            server_name localhost.test;
            # 设置代码根目录，后续则无需再设置根目录
            root /code;
            # 设置入口文件，或许无需再设置
            index index.php index.html;
        
            # 路由重定向：优先按文件夹路径匹配，其次才是index.php的入口设置
            # 适用于入口文件在文件夹下，而不是root根目录的框架。例如：Yii，Laravel等
            location / {
                try_files $uri $uri/ /index.php$is_args$args;
            }
        
            location ~ \.php {
                fastcgi_pass 127.0.0.1:9000;
                fastcgi_index index.php;
                # 根据上面设置的root的根目录来确定$document_root
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                include fastcgi_params;
            }
        }
        ```
        
        重启nginx
        
            systemctl reload nginx

#### 安装参考
* [通过yum安装PHP7](https://www.cnblogs.com/shifu204/p/7243576.html)
* [Centos下yum怎么安装php7](https://www.php.cn/php-weizijiaocheng-379696.html)
* [CENTOS 7 YUM 安装PHP7.4](https://blog.csdn.net/qq_35845964/article/details/110246464)
* [CentOS 7 yum 安装 PHP7.3 教程](https://blog.csdn.net/laohe08/article/details/93166590)
* [使用epel和remi第三方yum源，安装指定常用版本php](https://blog.csdn.net/lituxiu/article/details/90057277)
* [CentOS7 安装 php7.4](https://www.jianshu.com/p/c22d70c47a8c)

#### 报错参考
* [安装epel-release后报错，解决办法](http://blog.sina.com.cn/s/blog_e9dca8f00102y5zg.html)
* [Linux(Redhat 7.0) yum无法使用和subscription-manager提示](https://www.jianshu.com/p/7f22bb72a681)
* [安装错误提示：This system is not registered with an entitlement server. You can use subscription-manager to register.](https://blog.csdn.net/oraoharu/article/details/106808108)

#### 知识点参考
* [php.ini中的cgi.fix_pathinfo选项](https://taobig.org/?p=650)
* [nginx下支持PATH_INFO详解](https://www.nginx.cn/426.html)
* [nginx中的try_files指令解释](https://www.nginx.cn/279.html)
* [nginx 中 index try_files location 这三个配置项的作用](https://www.kancloud.cn/coding_up/php-linux/2158294)