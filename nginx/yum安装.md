
# 安装nginx
1. 查看可安装的版本

    yum list | grep nginx
    
2. 安装nginx
    
    yum install nginx
    
3. 查看nginx的路径
    ```
    # rpm -ql nginx
    /etc/logrotate.d/nginx
    /etc/nginx/fastcgi.conf
    /etc/nginx/fastcgi.conf.default
    /etc/nginx/fastcgi_params
    /etc/nginx/fastcgi_params.default
    /etc/nginx/koi-utf
    /etc/nginx/koi-win
    /etc/nginx/mime.types
    /etc/nginx/mime.types.default
    /etc/nginx/nginx.conf
    /etc/nginx/nginx.conf.default
    /etc/nginx/scgi_params
    /etc/nginx/scgi_params.default
    /etc/nginx/uwsgi_params
    /etc/nginx/uwsgi_params.default
    /etc/nginx/win-utf
    /usr/bin/nginx-upgrade
    /usr/lib/systemd/system/nginx.service
    /usr/lib64/nginx/modules
    /usr/sbin/nginx
    /usr/share/doc/nginx-1.16.1
    /usr/share/doc/nginx-1.16.1/CHANGES
    /usr/share/doc/nginx-1.16.1/README
    /usr/share/doc/nginx-1.16.1/README.dynamic
    /usr/share/doc/nginx-1.16.1/UPGRADE-NOTES-1.6-to-1.10
    /usr/share/licenses/nginx-1.16.1
    /usr/share/licenses/nginx-1.16.1/LICENSE
    /usr/share/man/man3/nginx.3pm.gz
    /usr/share/man/man8/nginx-upgrade.8.gz
    /usr/share/man/man8/nginx.8.gz
    /usr/share/nginx/html/404.html
    /usr/share/nginx/html/50x.html
    /usr/share/nginx/html/en-US
    /usr/share/nginx/html/icons
    /usr/share/nginx/html/icons/poweredby.png
    /usr/share/nginx/html/img
    /usr/share/nginx/html/index.html
    /usr/share/nginx/html/nginx-logo.png
    /usr/share/nginx/html/poweredby.png
    /usr/share/vim/vimfiles/ftdetect/nginx.vim
    /usr/share/vim/vimfiles/ftplugin/nginx.vim
    /usr/share/vim/vimfiles/indent/nginx.vim
    /usr/share/vim/vimfiles/syntax/nginx.vim
    /var/lib/nginx
    /var/lib/nginx/tmp
    /var/log/nginx
    ```
    
    整理路径
    ```
    # 配置路径
    /etc/nginx/
    
    # nginx.conf配置文件
    /etc/nginx/nginx.conf
    
    # 自动以配置路径
    /etc/nginx/default.d/*.conf
    
    # 执行程序
    /usr/sbin/nginx
    
    # 静态资源路径
    /usr/share/nginx/html/
    
    # 日志路径
    /var/log/nginx
    ```
    
#### 参考

