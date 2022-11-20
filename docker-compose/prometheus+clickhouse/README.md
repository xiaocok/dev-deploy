# Prometheus+Clickhouse



## 一、使用

### 1、运行

#### 1.1 给prometheus的目录响应的写权限

    chmod +777 prometheus/data

#### 1.2 创建网络

```shell
docker network create network-prometheus-clickhouse
```

#### 1.3 运行docker-compose

```shell
docker-compose up -d
```



#### 1.3 建数据库

Tabix页面

> clickhouse的web客户端

```text
http://宿主机IP:8000/
```

DBeaver

> 数据库管理软件

执行SQL语句

```sql
CREATE DATABASE IF NOT EXISTS metrics;
CREATE TABLE IF NOT EXISTS metrics.samples
(
      date Date DEFAULT toDate(0),
      name String,
      tags Array(String),
      val Float64,
      ts DateTime,
      updated DateTime DEFAULT now()
)
ENGINE = GraphiteMergeTree(
      date, (name, tags, ts), 8192, 'graphite_rollup'
);
```



#### 1.4 登录Grafana

**登录Grafana**

地址

```text
http://宿主机IP:3000
```

登录用户信息

```text
用户名：admin
密码：admin
```



**添加clickhouse数据源**

> Configuration > Data Sources > Add data source > 搜索 clickhouse > 选则 Altinity plugin for ClickHouse

地址输入：http://clickhouse-server:8123

> 这里是http，需要使用8123端口



**添加dashboard**

> Dashboard > Add New Panel > 输入下面的测试SQL > Refresh dashboard



添加测试SQL语句

> name的具体字段需要从metrics.sample表中去找对应的数据，ts根据数据中实际的值取出一个范围来查询

> 添加完成后，点击Refresh dashboard刷新，可以查看效果。

> Panel页面不会报SQL错误，如果SQL错误只是页面没数据显示，因此可以通过DBeaver调试SQL语句，再到Panel编辑。

```sql
SELECT
	name,
	tags,
	quantile(1)(val) as value
FROM
	metrics.samples
WHERE
	date >= toDate(1667660364)
	AND ts >= '2022-11-06 15:39:50'
	AND ts <= '2022-11-06 16:39:50'
	AND name = 'go_gc_duration_seconds'
GROUP BY
	name,
	tags
```





## 二、常用服务地址

### 2.1 页面访问Grafana
    http://宿主机IP:3000

**登录账号**

    用户名：admin
    密码：admin



**添加prometheus数据库**

    http://宿主机IP:9090



**添加clickhouse数据源**

```text
Grafana访问	http://clickhouse-server:8123
外部访问	   http://宿主机:8123
```



**常用Grafana模板**

    Node模板：8919
    Redis模板：763
    MySQL模板：7362,12826



### 2.2 Tabix页面

> clickhouse的web客户端

```text
http://宿主机IP:8000/
```



### 2.3 prom2click的地址

写地址

```text
http://宿主机IP:9201/write
```



读地址

```text
http://宿主机IP:9201/read
```



自身被prometheus采集的metrics地址

```text
http://宿主机IP:9201/metrics
```



### 2.4 ClickHouse-Server

ClickHouse-client

> DBeavr/Tabix需要使用8123

```text
http://宿主机IP:8123/
```

http服务

> prom2click需要使用9000

```text
http://宿主机IP:9000/
```



## 三、知识整理



Grafana安装clickhouse插件

[Run Grafana Docker image](https://grafana.com/docs/grafana/v9.0/setup-grafana/installation/docker/)

```shell
docker run -d \
  -p 3000:3000 \
  --name=grafana \
  -e "GF_INSTALL_PLUGINS=vertamedia-clickhouse-datasource" \
  grafana/grafana
```





## 参考

- [prometheus的远程存储到clickhouse里面，prometheus store clickhouse](https://blog.csdn.net/weixin_40126236/article/details/103821307)
- [Grafana上添加ClickHouse数据源](https://blog.51cto.com/u_13753753/5669276)
- https://github.com/mindis/prom2click
- https://hub.docker.com/r/fhalim/prom2click
- [告警功能配置说明](https://www.bookstack.cn/read/clickvisual-0.2-zh/d411d6e8f7858eb1.md)
- [ClickHouse常用SQL](https://www.bookstack.cn/read/clickvisual-0.2-zh/46b2c9ff9e325523.md)
- [uptrace/go-clickhouse](https://www.cnblogs.com/xiami303/p/16607609.html)
- [ClickHouse/clickhouse-go](https://github.com/ClickHouse/clickhouse-go)
