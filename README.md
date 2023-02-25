# 开发部署的环境

---

## 环境准备

- [开机启动脚本处理](环境准备/开机启动脚本处理.MD)

- [CentOS安装指定内核](环境准备/CentOS安装指定内核.md)

- [Vmware准备](环境准备/Vmware准备.md)

- [wsl安装（Windows子系统）](环境准备/wsl安装.md)



## 服务器环境部署

##### Linux常用命令
* [yum命令](server/yum命令.md)
---

##### Apollo

- [部署](server/Apollo/部署.md)

##### Elasticsearch

- [官方下载安装](server/Elasticsearch/官方下载安装.md)
- [安装](server/Elasticsearch/安装.md)

##### PHP

* PHP安装
  * yum安装PHP
    * [yum安装-remi源-推荐方式（支持最新版本）](server/PHP/yum安装/yum安装-remi源.md)
    * [yum安装-remi源-指定版本（支持最新版本）](server/PHP/yum安装/yum安装-remi源-指定版本.md)
    * [yum安装-webtatic源（最高支持PHP7.2）](server/PHP/yum安装/yum安装-webtatic源.md)
  * [macOS系统原生自带PHP配置](server/PHP/macOS安装.md)
  * [windows安装](server/PHP/windows安装.md)
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
    * [安装](server/Hyperf/安装.md)

##### Nginx
* Nginx安装
    * [yum安装](server/nginx/yum安装.md)
    * [macOS安装](server/nginx/macOS安装.md)
* [Nginx教程](server/nginx/教程.md)
---



## Docker部署

#### [docker+仓库 部署](docker/README.md)

* docker-ce安装
    * [CentOS安装](docker/docker-ce/CentOS安装.md)
    * [Ubuntu安装](docker/docker-ce/Ubuntu安装.md)
    * [Docker加速](docker/docker-ce/Docker加速.md)
* [harbor部署](docker/harbor)
* [clickhouse](docker/clickhouse/README.md)
* [consul](docker/consul)
* [consul+registrator+nginx-template](docker/consul+registrator+nginx-template/README.MD)
* [coredns](docker/coredns/README.md)
* [elasticsearch](docker/elasticsearch/部署.md)
* [etcd](docerk/etcd/说明.md)
* [mysql](docker/mysql)
* [nginx](docker/nginx)
* [php-fpm](docker/php-fpm)
* [prom2click](docker/prom2click)
* [RabbitMQ](docker/RabbitMQ/说明.md)
* [redis](docker/redis)
---



## Docker-Compose部署

* [Docker-Compose安裝](docker-compose/安装/README.md)
* [apollo](docker-compose/apollo/docker-quick-start)
* [core+etcd](docker-compose/core+etcd/README.md)
    * dns解析
    * dns反解析
    * 命令行注册dns
* [prometheus部署](docker-compose/prometheus)
    * 支持服务器采集监控
    * 支持MySQL数据库采集监控
    * 支持Redis数据库采集监控
    * 支持Grafana显示
    * 支持AlertManager告警
    * 支持钉钉推送
* [prometheus+clickhouse](docker-compose/prometheus+clickhouse/README.md)
    * 数据持久化之clickhouse
---



## Kubernetes

- [Kind安装](kubernetes/kind/README.md)

- [Kubeadm安装](kubernetes/kubeadm安装)
  - 使用Kubeadm创建集群
    - 安装docker-ce
    - 安装Etcd
    - 环境准备
    - 安装kubeadm
    - 部署Kubernetes集群
    - 加入节点
    - 清理
    - 安装扩展（Addons）
    - Kubeadm故障排查
  - 参考
