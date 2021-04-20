# 开发部署的环境

---

## 服务器环境部署

##### PHP
* PHP Composer
    * [Linux安装composer](server/PHP/Composer/Linux安装composer.md)
    * [Windows安装composer](server/PHP/Composer/windows安装composer.md)
    * [Composer加速](server/PHP/Composer/composer加速.md)
    * [Composer使用教程](server/PHP/Composer/使用教程.md)
    
* Laravel
    * [Laravel安装+Linux环境配置](server/PHP/Laravel/Laravel安装+Linux环境配置.md)
    * [Homestead环境安装](server/PHP/Laravel/Homestead环境.md)
    * [PHPStorm的laravel框架代码追踪提示](server/PHP/Laravel/PHPStrom配置.md)

* PHP安装
    * yum安装PHP
        * [yum安装-remi源-推荐方式（支持最新版本）](server/PHP/yum安装/yum安装-remi源.md)
        * [yum安装-remi源-指定版本（支持最新版本）](server/PHP/yum安装/yum安装-remi源-指定版本.md)
        * [yum安装-webtatic源（最高支持PHP7.2）](server/PHP/yum安装/yum安装-webtatic源.md)
    * [macOS系统原生自带PHP配置](server/PHP/macOS安装.md)
    * [源码安装PHP](server/PHP/源码安装.md)

##### Nginx
* Nginx安装
    * [yum安装](server/nginx/yum安装.md)
    * [macOS安装](server/nginx/macOS安装.md)
* [Nginx教程](server/nginx/教程.md)
---

## Docker部署
#### docker+仓库 部署
* [docker-ce安装](docker/docker-ce)
* [harbor部署](docker/harbor)
---

## Docker-Compose部署

* [prometheus部署](docker-compose/prometheus)
    * 支持服务器采集监控
    * 支持MySQL数据库采集监控
    * 支持Redis数据库采集监控
    * 支持Grafana显示
    * 支持AlertManager告警
    * 支持钉钉推送
---

## Kubernetes
