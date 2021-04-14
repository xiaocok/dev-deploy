
# macOS安装nginx

### 安装
    brew install nginx
  
### 开机启动
    $ sudo cp `brew --prefix nginx`/homebrew.mxcl.nginx.plist /Library/LaunchDaemons/
    $ sudo sed -i -e 's/`whoami`/root/g' `brew --prefix nginx`/homebrew.mxcl.nginx.plist

### 相关路径
  | 说明  | 路径 |
  | :--- | :--- |
  | nginx配置目录       | /usr/local/etc/nginx |
  | nginx.conf配置文件  | /usr/local/etc/nginx/nginx.conf |
  | 新增servers目录     | /usr/local/etc/nginx/servers |
  | nginx运行pid文件路径 | /usr/local/var/run/ |
  | fastcgi配置        | /usr/local/etc/nginx/fastcgi_params |


### 日志目录设置
  创建日志目录
    
    sudo mkdir /var/log/nginx/
  
  修改配置文件
  
    vim /usr/local/etc/nginx/nginx.conf
    修改
    access_log = /var/log/nginx/access.log
    error_log = /var/log/nginx/error.log

### 命令行
    启动      nginx
    停止      nginx -s stop
    重新加载   ngin -s reload

### nginx配置模板
  ```
  server {
      listen       8080;
      server_name  localhost;

      #charset koi8-r;

      #access_log  logs/host.access.log  main;

      location / {
          root   html;
          index  index.html index.htm;
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
      #location ~ \.php$ {
      #    root           html;
      #    fastcgi_pass   127.0.0.1:9000;
      #    fastcgi_index  index.php;
      #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
      #    include        fastcgi_params;
      #}

      # deny access to .htaccess files, if Apache's document root
      # concurs with nginx's one
      #
      #location ~ /\.ht {
      #    deny  all;
      #}
  }
  ```
  
#### 参考
* [MacOS 安装 nginx](https://www.cnblogs.com/iosdev/p/3345390.html)
