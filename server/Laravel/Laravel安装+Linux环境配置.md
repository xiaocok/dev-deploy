
# laravel配置
1. 安装composer

2. 安装 Laravel
    * 方式一： Laravel 安装器
        ```
        composer global require laravel/installer
        laravel new blog
        ```
    * 方式二：通过 Composer 创建项目（推荐方式）
        ```
        composer create-project --prefer-dist laravel/laravel blog
        ```

        使用以下命令来创建指定版本的 Laravel 项目：
        ```
        composer create-project laravel/laravel project-name --prefer-dist "5.5.*"
        ```

        例如：7.x的最新版
        ```
        composer create-project laravel/laravel blog --prefer-dist "7.*.*"
        ```

3. web服务器配置

    Nginx
    
    如果你使用 Nginx ，在你的站点配置中加入以下配置，所有的请求将会引导至 index.php 前端控制器：
    ```text
    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }
    ```

    全部配置
    ```
    server {
        listen       80;
        server_name  localhost;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;
        
        root   html;
        index  index.php index.html index.htm;

        location / {
            try_files $uri $uri/ /index.php?$query_string;
        }

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }

        # proxy the PHP scripts to Apache listening on 127.0.0.1:80
        #
        #location ~ \.php$ {
        #    proxy_pass   http://127.0.0.1;
        #}

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        location ~ \.php$ {
            #root           html;
            fastcgi_pass   127.0.0.1:9000;
            fastcgi_index  index.php;
            #fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
            fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
            include        fastcgi_params;
        }

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        #location ~ /\.ht {
        #    deny  all;
        #}
    }
    ```


#### 文档
* [Laravel 社区 Wiki](https://learnku.com/laravel/wikis)
* [Laravel 7 中文文档](https://learnku.com/docs/laravel/7.x/installation/7447)
* [Laravel 项目开发规范](https://learnku.com/docs/laravel-specification/7.x)
* [Laravel 速查表](https://learnku.com/docs/laravel-cheatsheet/7.x)

#### 参考
* [Laravel 版本选择](https://learnku.com/docs/laravel-specification/7.x/laravel-version-selection/7591)
* [Laravel 安装和开发环境：创建 Laravel 应用](https://learnku.com/laravel/wikis/25520)
* [使用 Laravel new 指令创建项目如何制定版本](https://learnku.com/laravel/t/24626)
