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
```



