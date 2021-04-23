# 开发部署的环境

---

## 服务器环境部署

##### Linux常用命令
* yum命令
    
---

##### PHP
* PHP安装
  * yum安装PHP
    * [yum安装-remi源-推荐方式（支持最新版本）](server/PHP/yum安装/yum安装-remi源.md)
    * [yum安装-remi源-指定版本（支持最新版本）](server/PHP/yum安装/yum安装-remi源-指定版本.md)
    * [yum安装-webtatic源（最高支持PHP7.2）](server/PHP/yum安装/yum安装-webtatic源.md)
  * [macOS系统原生自带PHP配置](server/PHP/macOS安装.md)
  * [源码安装PHP](server/PHP/源码安装.md)
  * [PHP扩展安装](server/PHP/PHP扩展安装.md)

* PHP Composer
    * [Linux安装composer](server/Composer/Linux安装composer.md)
    * [Windows安装composer](server/Composer/windows安装composer.md)
    * [Composer加速](server/Composer/composer加速.md)
    * [Composer使用教程](server/Composer/使用教程.md)
    
* Laravel
    * Homestead环境安装
        * [Homestead环境部署](server/Laravel/Homestead/Homestead环境.md)
        * [安装PHP扩展](server/Laravel/Homestead/安装PHP扩展.md)
    * [Laravel安装+Linux环境配置](server/Laravel/Laravel安装+Linux环境配置.md)
    * [PHPStorm的laravel框架代码追踪提示](server/Laravel/PHPStrom配置.md)

* PHP Swoole
    * [Swoole安装](server/Swoole/安装.md)
* PHP Hyperf
    * Hyperf安装

##### Nginx
* Nginx安装
    * [yum安装](server/nginx/yum安装.md)
    * [macOS安装](server/nginx/macOS安装.md)
* [Nginx教程](server/nginx/教程.md)
---

## Docker部署
#### docker+仓库 部署
* docker-ce安装
    * [CentOS安装](docker/docker-ce/CentOS安装.md)
    * [Ubuntu安装](docker/docker-ce/Ubuntu安装.md)
    * [Docker加速](docker/docker-ce/Docker加速.md)
* [harbor部署](docker/harbor)
---

## Docker-Compose部署
* [Docker-Compose安裝](docker-compose/安装/README.md)
* [prometheus部署](docker-compose/prometheus)
    * 支持服务器采集监控
    * 支持MySQL数据库采集监控
    * 支持Redis数据库采集监控
    * 支持Grafana显示
    * 支持AlertManager告警
    * 支持钉钉推送
---

## Kubernetes
