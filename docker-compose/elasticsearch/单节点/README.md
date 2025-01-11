

7.10为免费版，后续版本为收费版，至提供30天免费试用



### 执行

```shell
docker-compose up -d
```



### 安装分词器

#### 手动安装

```shell
cd es-plugins
unzip elasticsearch-analysis-ik-7.17.5.zip -d analysis-ik
docker-compose restart
```

#### 命令安装

```shell
docker-compose exec elasticsearch bin/elasticsearch-plugin list
docker-compose exec elasticsearch bin/elasticsearch-plugin install analysis-icu

docker-compose exec elasticsearch bin/elasticsearch-plugin install https://get.infini.cloud/elasticsearch/analysis-ik/7.17.5

docker-compose restart
```



#### 设置kibana中文

```shell
# 配置文件最后一行增加中文设置
docker-compose exec kibana sed -i '$a i18n.locale: "zh-CN"' /usr/share/kibana/config/kibana.yml

# 重启
docker-compose restart kibana
```

