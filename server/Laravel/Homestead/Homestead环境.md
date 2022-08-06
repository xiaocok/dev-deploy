
# Laravel Homestead

### 生成SSH key，启动vagrant的Homestead.yaml配置文件需要使用

注意：用于免密登录，如果不需要免密登录，则无需该步骤

安装 Git for Windows

    下载地址：https://git-for-windows.github.io
    注意：Windows 下，~ 目录代表着 C:\Users\你的用户名，而 ~/Homestead 代表着 C:\Users\你的用户名\Homestead 目录

主机生成 SSH Key

    1. 执行命令
        > ssh-keygen -t rsa -C "your_email@example.com"
        Generating public/private rsa key pair.
    
        注意：
            请将 your_email@example.com 替换为你的邮箱
            
    2. 按回车确认，默认空密码
    
    3. 执行完成后，查看
        > ls -al ~/.ssh

        存在 id_rsa 和 id_rsa.pub 的文件，即为生成成功
        
        SSH 秘钥的两个文件：
            id_rsa —— SSH 秘钥的 私钥 (Private Key)
            id_rsa.pub —— SSH 秘钥的 公钥 (Public Key)

配置应用

[Homestead 配置说明](https://learnku.com/laravel/wikis/25530)
    
    适用于Homestead.yaml文件的一下2项：
        authorize: C:\Users\xxx\.ssh\id_rsa.pub
        
        keys:
            - C:\Users\xxx\.ssh\id_rsa
    具体路径为上面生成的实际路径

    应用配置修改    
        如果Homestead.yaml文件修改后，需要执行命令后才生效。
        在 主机 中使用以下命令应用修改到 Homestead 虚拟机中：
        > vagrant reload --provision

### 安装 VirtualBox
    
    下载地址：https://www.virtualbox.org/wiki/Downloads

<br/>

---
### 安装 Homestead Vagrant Box
        
* 版本号说明
    
    官方地址：https://github.com/laravel/homestead
    
    | Ubuntu LTS | Settler Version | Homestead Version | Branch | Status |
    | :---       | :---            | :---              | :---   | :---   |
    | 20.04	     | 11.x	           | 12.x	           | main	| Development/Unstable |
    | 20.04	     | 11.x	           | 12.x	           | release| Stable |
    | box的ubuntu版本 | box下载的版本 | github下载的homestead版本 | github分支 | 稳定性 |
    
* 命令行安装
    安装最新版本：
    
        $ vagrant box add laravel/homestead 

    或者指定版本：

        $ vagrant box add laravel/homestead --box-version=0.3.3

    备注：安装过程中可以查看到box的下载地址，如果安装较慢，可以直接下载box，然后导入

* 导入本地box（下载本地后导入）

    * 方式一：下载地址
    
        Laravel的vagrant的box下载地址：
    
            https://app.vagrantup.com/laravel/boxes/homestead
    
        Laravel的vagrant的github源码地址：
    
            https://github.com/laravel/settler
    
        homestead的v11的下载地址：
        
            #从上面的box add命令中获取，也可从官方box下载页面获取
            https://vagrantcloud.com/laravel/boxes/homestead/versions/11.0.0/providers/virtualbox.box
        
        百度盘 Homestead 主要版本下载
        
            http://pan.baidu.com/s/1hrN55w4

    * 方式二：导入box
    
        下载成功 .box 文件后，就可以本地导入盒子了。
        
        在 .box 的同文件夹下创建一个 metadata.json 文件，内容为以下：
        ```
        {
            "name": "laravel/homestead",
            "versions":
            [
                {
                    "version": "0.4.4",
                    "providers": [
                        {
                          "name": "virtualbox",
                          "url": "homestead-virtualbox-0.4.4.box"
                        }
                    ]
                }
            ]
        }
        ```
        
        字段说明
        
            name    - 这是导入盒子的名词，理论上，可以任意命名。当然，除非你知道自己在干嘛，否则建议使用 Laravel 默认的；
            version - 可以指定当前盒子导入的版本标示，你可以随意指定，不过建议保持你下载盒子时的版本；
            url     - 指定盒子的路径，支持绝对文件路径和相对文件路径。
            注：上面的版本请按需修改。
            
        运行以下命令导入：
      
            $ vagrant box add metadata.json

* 删除 Homestead Box

    用于重新制作Homestead Box
    
    首先列表所有盒子：
    
        > vagrant box list
        lc/homestead (virtualbox, 6.1.1)
        laravel/homestead (virtualbox, 6.0.0)
        laravel/homestead (virtualbox, 6.1.0)
        
    选择你要删除的盒子，指定版本进行删除：

        > vagrant box remove laravel/homestead --box-version 6.0.0

### 安装 Homestead

你可以通过克隆代码来安装 Homestead。建议将代码克隆到你的「home」目录下的 Homestead 文件夹中，这样 Homestead box 就可以作为你的所有 Laravel 项目的主机：

    git clone https://github.com/laravel/homestead.git ~/Homestead

因为 Homestead 的 master 分支并不是稳定的，你应该使用打过标签的稳定版本。您可以在 GitHub Release Page 上找到最新的稳定版。或者，你可以查看包含最新稳定版本的 release 分支：

     cd ~/Homestead
     git checkout release

一旦克隆 Homestead 代码完成以后，在 Homestead 目录中使用 bash init.sh 命令来创建 Homestead.yaml 配置文件。Homestead.yaml 文件将被放在 Homestead 目录中：

   // Mac / Linux...
   bash init.sh
   
   // Windows...
   init.bat

<br/>

---
### 配置 Homestead

[Homestead 配置说明](https://learnku.com/laravel/wikis/25530)

编辑Homestead.yaml配置文件

#### 免密登录
    
    authorize: C:\Users\xxx\.ssh\id_rsa.pub
    keys:
        - C:\Users\xxx\.ssh\id_rsa
    
    注意：上面配置的免密登录，如果无需免密登录，则这里不需要配置，注释掉

#### 设置你的提供器
    
    provider: virtualbox
    
#### 配置共享文件夹

    folders:
        - map: ~/code/project1
          to: /home/vagrant/project1
          
    注意：Windows 用户不应使用 〜/ 路径语法，而应使用其项目的完整路径，例如 C:\Users\user\Code\project1。

#### 配置 Nginx 站点

    sites:
        - map: homestead.test
          to: /home/vagrant/project1/public

#### 主机名解析
在 Mac 和 Linux 系统中，该文件位于 /etc/hosts，在 Windows 系统中，该文件位于 C:\Windows\System32\drivers\etc\hosts。我们以 homestead.test 域名映射为例，添加到 hosts 文件的记录如下所示：        
    
    192.168.10.10  homestead.test

确保 IP 地址和你的 Homestead.yaml 文件中的配置项一致，一旦你将域名添加到 hosts 文件中并启动 Homestead，就可以在浏览器中通过该域名访问站点了：
    
    http://homestead.test
    
#### 启动 Vagrant 盒子
根据你的需求编辑完成 Homestead.yaml，在你的 Homestead 文件夹中运行 vagrant up 命令。Vagrant 将启动虚拟机并自动配置你的共享文件夹和 Nginx 站点。

若要删除虚拟机，只需要运行 vagrant destroy --force 命令。

#### 根据项目安装
除了全局安装 Homestead 并且在所有项目共享相同的 Homestead box 之外， 你可以为每个项目配置 Homestead 实例。 通过在项目下创建 Vagrantfile，其他的项目成员只需运行 vagrant up 就能拥有相同的开发环境。
    
要将 Homestead 直接安装到项目中，需要使用 Composer 命令：
    
    composer require laravel/homestead --dev
        
Homestead 安装之后， 使用 make 命令在项目根目录中生成 Vagrantfile 和 Homestead.yaml 文件。 make 命令会自动配置 Homestead.yaml 文件中 sites 和 folders 指令。

Mac / Linux:

    php vendor/bin/homestead make
Windows:

    vendor\\bin\\homestead make

##### 关于配置修改、重建box    
注意：Homestead 脚本被设计为尽可能保证操作的幂等，不过，如果你在 provison 过程中还是出现问题，则需要通过 vagrant destroy && vagrant up 命令来销毁并重构虚拟机。
 
应用配置Homestead.yaml修改，需要执行以下操作才生效
    
    在 主机 中使用以下命令应用修改到 Homestead 虚拟机中：
    > vagrant reload --provision

如果box出现异常，需要重建box

    如果你在 provison 过程中还是出现问题，则需要通过 vagrant destroy && vagrant up 命令来销毁并重构虚拟机。

<br/>

---
### Homestead 下切换 PHP 版本
#### 前言

Laravel 的 Homestead 中自带了 PHP5.6、PHP7.0、PHP7.1 和 PHP7.2 这 4 个版本。默认运行的最高版本 7.2, 但有时公司需求不得不切换到别的版本。怎么切换呢？Homestead 中自带了切换版本的方式，如下：
```yaml
sites:
    - map: homestead.test
      to: /home/vagrant/code/Laravel/public
      php: "5.6"
```
但是，当你在 homestead 中执行 composer 时，或者用 php -v 查看 php 版本时，还是最高版本 7.2 的。导致 composer 进行版本检查时或者更新包时，都是按照 7.2 版本来更新的。怎么办呢，homestead 中自带了版本管理工具
update-alternatives

用法如下：
```shell
update-alternatives --display php 查看所有 php 版本和当前版本
update-alternatives --config php 执行后，会列出当前 php 所有版本和编号，输入编号，切换到执行的版本
```

之前没注意 Homestead 目录下有个 aliases 文件，这个文件中定义了一些可以直接在虚拟机中使用的命令，比如想切换到 7.0 版本直接执行
```shell
php70 即可
```
<br/>


---
#### 参考：
[Laravel 7 中文文档 / Laravel Homestead](https://learnku.com/docs/laravel/7.x/homestead/7450)
<br/>

#### Laravel Homestead
* 介绍
* 安装与设置
    * 第一步
    * 配置 Homestead
    *  Vagrant Box
    * 根据项目安装
    * 安装可选功能
    * 别名
* 日常使用
    * 全局可用的 Homestead
    * 通过 SSH 连接
    * 连接数据库
    * 数据库备份
    * 数据库快照
    * 添加其他站点
    * 环境变量
    * 配置 Cron 调度器
    * 配置 Mailhog
    * 配置 Minio
    * 端口
    * 共享你的环境
    * 多个 PHP 版本
    * Web 服务器
    * 邮件
* 调试与分析
    * 使用 Xdebug 调试 Web 请求
    * 调试 CLI 应用程序
    * 使用 Blackfire 分析应用程序
* 网络接口
* 扩充 Homestead
* 更新 Homestead
* 提供器的特殊设置
    * VirtualBox

#### 内置软件
* Ubuntu 18.04
* Git
* PHP 7.4
* PHP 7.3
* PHP 7.2
* PHP 7.1
* PHP 7.0
* PHP 5.6
* Nginx
* MySQL
* lmm for MySQL or MariaDB database snapshots
* Sqlite3
* PostgreSQL
* Composer
* Node (With Yarn, Bower, Grunt, and Gulp)
* Redis
* Memcached
* Beanstalkd
* Mailhog
* avahi
* ngrok
* Xdebug
* XHProf / Tideways / XHGui
* wp-cli

#### 可选软件
* Apache
* Blackfire
* Cassandra
* Chronograf
* CouchDB
* Crystal & Lucky Framework
* Docker
* Elasticsearch
* Gearman
* Go
* Grafana
* InfluxDB
* MariaDB
* MinIO
* MongoDB
* MySQL 8
* Neo4j
* Oh My Zsh
* Open Resty
* PM2
* Python
* RabbitMQ
* Solr
* Webdriver & Laravel Dusk Utilities

<br/>

#### Laravel 社区 Wiki
* [ Laravel Homestead](https://learnku.com/laravel/wikis/26268)
* [ Laravel Homestead：加速下载和安装](https://learnku.com/laravel/wikis/25528)
* [Laravel Homestead：删除 Homestead Box](https://learnku.com/laravel/wikis/26273)
* [Laravel Homestead：所有配置详解](https://learnku.com/laravel/wikis/25530)
* [Laravel Homestead：切换 PHP 版本](https://learnku.com/laravel/wikis/25545)
* [Laravel Homestead：安装 MariaDB](https://learnku.com/laravel/wikis/25531)
* [Laravel Homestead：安装 MongoDB 数据库](https://learnku.com/laravel/wikis/25532)
* [Laravel Homestead：安装 Elasticsearch 搜索引擎](https://learnku.com/laravel/wikis/25533)
* [Laravel Homestead：root 的密码是什么？](https://learnku.com/laravel/wikis/37099)

#### ★ Laravel Homestead文档 ★
* [Laravel 5.x](https://learnku.com/docs/laravel/5.1/homestead/1040)
* [Laravel 7.x](https://learnku.com/docs/laravel/7.x/homestead/7450)
* [Laravel 8.x](https://learnku.com/docs/laravel/8.x/homestead/9357)

#### Homestead 下切换 PHP 版本
* [Homestead 下切换 PHP 版本](https://learnku.com/articles/16881)
* [homestead修改php版本](https://www.cnblogs.com/ifme/p/11398414.html)

#### 参考
* [Windows 环境下搭建 Laravel 开发环境 Homestead (含所有资源链接)](https://learnku.com/laravel/t/2178/windows-environment-to-build-laravel-development-environment-homestead-including-all-the-resources-link)
* [如何在 Windows 上安装 Laravel Homestead](https://learnku.com/laravel/t/2519/how-to-install-laravel-windows-on-homestead)
* [Homestead 安装需要知道的一些信息](https://learnku.com/laravel/t/2090/homestead-installation-needs-to-know-some-information)
* [解决 Homestead 版本与 homestead.box 不对应造成的冲突](https://learnku.com/laravel/t/3494/resolve-the-conflict-between-the-homestead-version-and-homesteadbox)
