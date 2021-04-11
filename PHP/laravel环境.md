
# laravel配置
1. 安装composer

2. 安装 Laravel
    * 通过 Laravel 安装器
        ```
        composer global require laravel/installer
        laravel new blog
        ```
    * 通过 Composer 创建项目
        ```
        composer create-project --prefer-dist laravel/laravel blog
        ```
        
        支持指定版本
        ```
        composer create-project laravel/laravel blog "7.*.*"
        ```

3. web服务器配置

    Nginx
    
    如果你使用 Nginx ，在你的站点配置中加入以下配置，所有的请求将会引导至 index.php 前端控制器：
    ```text
    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }
    ```


#### 参考
* [Laravel 7 中文文档](https://learnku.com/docs/laravel/7.x/installation/7447)
* [使用 Laravel new 指令创建项目如何制定版本](https://learnku.com/laravel/t/24626)