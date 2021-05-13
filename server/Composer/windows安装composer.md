
# windows安装composer

注意：
    Phpstudy内部支出composer插件，可以全自动化安装。

### 先下载Composer-Setup.exe
下载地址：[下载Composer](https://getcomposer.org/Composer-Setup.exe) 。会自动搜索php.exe的安装路径,如果没有，就手动找到php路径下的php.exe。

官网下载地址：https://getcomposer.org/download/

### 安装
1. 在PHP目录下，打开php.ini文件，开启openssl扩展。去掉extension=php_openssl.dll前面的分号(;)

    如果安装不成功，可能是之前安装过composer没有卸载干净，其实composer就是一些php文件，找到他们删除即可。
   
        composer remove：移除composer
        composer config -l -g | grep "home|dir" -E：找到对应的目录
        where composer：找到对应的安装位置

2. 把php目录添加到环境变量（和php.exe同级目录的路径）例如：D:\apache_php\php添加到环境变量path里。
    注意：<br/>
    1.php安装时，如果已经添加了环境变量，则无需再添加。<br/>
    2.composer安装时，会提示是否添加composer的环境变量。<br/>

3. 简化命令
   
    下载composer.phar,下载地址：Composer.phar。
    
    将composer.phar文件放入php目录下，在php目录下新建一个文件composer.cmd，内容写成：@php "%~dp0composer.phar" %*保存。
    
    运行这个文件，然后会自动打开cmd运行：会出现composer界面

    可以运行composer --version 查看composer的版本。
   
4. 在命令行中执行
    
    composer config -g repo.packagist composer https://packagist.phpcomposer.com

    改写Packagist 镜像至国内镜像可以加快下载速度。
   

#### 参考
* [Windows环境下Composer的安装教程](https://blog.csdn.net/iloveyougirls/article/details/52333597)
* [Windows下安装Composer的详细教程](https://blog.csdn.net/wengedexiaozao/article/details/79893672)
* [composer安装及配置（Windows）](https://blog.csdn.net/qq_38125058/article/details/81280437)