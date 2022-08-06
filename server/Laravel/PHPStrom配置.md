
# 代码追踪提示

guihub地址：https://github.com/barryvdh/laravel-ide-helper


1. 在phpstorm ---> file ---> settings ---> plugins ---> 搜索Laravel Plugin ---> 安装

2. 安装ide-helper插件
    1. 安装
        ```
        composer require barryvdh/laravel-ide-helper
        如果安装失败的话先执行下 composer update 命令即可。
        ```
    2. 分别执行下面三个命令
        ```
        php artisan ide-helper:eloquent
        php artisan ide-helper:generate
        php artisan ide-helper:meta
        ```
3. 代码有提示并且可以反向追踪，也可以直接跳转到使用app方法加载类的方法。



#### 官方文档
* [laravel6 使用的laravel-ide-helper版本文档说明](https://github.com/barryvdh/laravel-ide-helper/tree/v2.8.0)


#### 参考
* [laravel框架中实现代码追踪（PHPstorm IDE）](https://blog.csdn.net/u013957017/article/details/88573529)
* [Laravel 超好用代码提示工具 Laravel IDE Helper](https://learnku.com/articles/10172/laravel-super-good-code-prompt-tool-laravel-ide-helper)
* [phpstorm对laravel开发的配置](https://www.cnblogs.com/qiuhao/p/13321864.html)

