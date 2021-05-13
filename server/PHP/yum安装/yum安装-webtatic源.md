
# 通过yum安装PHP7

### 说明
> 默认安装的版本较低，安装高版本，需要使用三方源

1. 检查当前安装的PHP包
    ```
    yum list installed | grep php
    ```
    
    如果有安装的PHP包，先卸载
    ```
    yum remove php.x86_64 php-cli.x86_64 php-common.x86_64 php-gd.x86_64 php-ldap.x86_64 php-mbstring.x86_64 php-mcrypt.x86_64 php-mysql.x86_64 php-pdo.x86_64
    ```
    
    卸载全部
    ```
    yum remove php*
    ```
2. 安装三方源
    
    CentOS 5.x
    ```
    rpm -Uvh http://mirror.webtatic.com/yum/el5/latest.rpm
    ```
    CentOS 6.x
    ```
     rpm -Uvh http://mirror.webtatic.com/yum/el6/latest.rpm
    ```
    CentOS 7.x 两个命令都要执行
    ```
    rpm -Uvh https://mirror.webtatic.com/yum/el7/epel-release.rpm
    rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
    ```
    
    如果想卸载上面安装的包，重新安装
    ```
    rpm -qa | grep webstatic
    rpm -e  上面搜索到的包即可
    ```

3. 安装
    例如：5.5
    ```
    yum install php55w.x86_64 php55w-cli.x86_64 php55w-common.x86_64 php55w-gd.x86_64 php55w-ldap.x86_64 php55w-mbstring.x86_64 php55w-mcrypt.x86_64 php55w-mysql.x86_64 php55w-pdo.x86_64
    ```
    
    例如：5.6
    ```
    yum install php56w.x86_64 php56w-cli.x86_64 php56w-common.x86_64 php56w-gd.x86_64 php56w-ldap.x86_64 php56w-mbstring.x86_64 php56w-mcrypt.x86_64 php56w-mysql.x86_64 php56w-pdo.x86_64
    ```

    例如：7.0
    ```
    yum install php70w.x86_64 php70w-cli.x86_64 php70w-common.x86_64 php70w-gd.x86_64 php70w-ldap.x86_64 php70w-mbstring.x86_64 php70w-mcrypt.x86_64 php70w-mysql.x86_64 php70w-pdo.x86_64
    ```
    注：如果想升级到7.0，把上面的55w换成70w就可以了

    **如果出现异常，参见报错参考**

4. 安装PHP FPM
    ```
    yum install php55w-fpm
    yum install php56w-fpm
    yum install php70w-fpm
    ```



#### 参考
* [通过yum安装PHP7](https://www.cnblogs.com/shifu204/p/7243576.html)


#### 报错参考
* [Linux(Redhat 7.0) yum无法使用和subscription-manager提示](https://www.jianshu.com/p/7f22bb72a681)
* [安装错误提示：This system is not registered with an entitlement server. You can use subscription-manager to register.](https://blog.csdn.net/oraoharu/article/details/106808108)