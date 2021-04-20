

# Composer 加速

### 1、配置全局加速
#### 国内通用加速
    $ composer config -g repo.packagist composer https://packagist.phpcomposer.com

#### laravel加速
    $ composer config -g repo.packagist composer https://packagist.laravel-china.org

#### 阿里云加速
    $ composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

### 2、配置当前项目加速
#### 例如：阿里云
    $ composer config repo.packagist composer https://mirrors.aliyun.com/composer/

### 3、取消加速
    $ composer config -g --unset https://mirrors.aliyun.com/composer/

### 4、查看Composer全局设置
    $ composer config -gl

### 5、加速地址
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

### 6、使用第三方软件快速修改、切换 composer 镜像源
命令：

    crm composer registry manager

crm地址：

    https://github.com/slince/composer-registry-manager

安装 crm
    
    composer global require slince/composer-registry-manager

列出可用的所有镜像源，前面带 * 代表当前使用的镜像

    composer repo:ls
    -- --------------- ------------------------------------------------
         composer        https://packagist.org
         phpcomposer     https://packagist.phpcomposer.com
         aliyun          https://mirrors.aliyun.com/composer
         tencent         https://mirrors.cloud.tencent.com/composer
         huawei          https://mirrors.huaweicloud.com/repository/php
         laravel-china   https://packagist.laravel-china.org
         cnpkg           https://php.cnpkg.org
         sjtug           https://packagist.mirrors.sjtug.sjtu.edu.cn
    -- --------------- ------------------------------------------------

使用 aliyun 镜像源

    composer repo:use aliyun

    # 执行成功之后会输出类似以下信息
    [OK] Use the repository [aliyun] success

再次执行 composer repo:ls 命令，看到前面带 * 的就是当前使用的镜像

    composer repo:ls 
    # 可以看到 aliyun 前面有一个 * 号，代表当前使用的是 aliyun 的源


#### 参考
* [Composer 国内加速](https://www.imooc.com/article/details/id/293297)
* [Composer 国内加速，修改镜像源](https://learnku.com/articles/15977/composer-accelerate-and-modify-mirror-source-in-china)
* [Composer 设置国内镜像加速命令](https://blog.csdn.net/qq_39479575/article/details/78515219)
* [Laravel 安装和开发环境：Composer 国内加速镜像](https://learnku.com/laravel/wikis/25522)
* [php项目构建速度优化 composer加速](https://blog.csdn.net/t_1007/article/details/86702737)
