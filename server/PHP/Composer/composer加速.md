

# Composer 加速

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

#### 参考
* [Composer 国内加速](https://www.imooc.com/article/details/id/293297)
* [Composer 设置国内镜像加速命令](https://blog.csdn.net/qq_39479575/article/details/78515219)
* [Laravel 安装和开发环境：Composer 国内加速镜像](https://learnku.com/laravel/wikis/25522)
* [php项目构建速度优化 composer加速](https://blog.csdn.net/t_1007/article/details/86702737)
