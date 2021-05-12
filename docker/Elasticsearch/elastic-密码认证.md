

## 部署带认证的 Kibana 和 Elasticsearch

### 开启Elasticsearch的安全认证
1. 停止已经在运行的 Kibana 和 Elasticsearch
2. 配置elasticsearch.yml，添加
    ```yaml
    xpack.security.enabled: true
    ```
    如果是rpm安装，路径在/etc/elasticsearch/elasticsearch.yml
3. 如果Elasticsearch运行的单例模式，还需要添加
    ```yaml
    discovery.type: single-node
    ```
    此设置可确保节点不会无意中连接到网络上可能正在运行的其他群集。

### 给Elasticsearch创建账号密码
1. 如果是.tar.gz方式安装的Elasticsearch，则运行以下命令，启动elasticsearch
    ```shell
    ./bin/elasticsearch
    ```

2. 创建密码
   
    **自动生成密码**
    ```shell
    ./bin/elasticsearch-setup-passwords auto
    ```
    生成如下类似账号密码信息
    ```text
    Changed password for user apm_system
    PASSWORD apm_system = kRttJfs11EJwCmHeWmlk
    
    # 给kibana使用的账号密码
    Changed password for user kibana_system
    PASSWORD kibana_system = BYKwqWTxvA7ZpdQuA8sY
    
    Changed password for user kibana
    PASSWORD kibana = BYKwqWTxvA7ZpdQuA8sY
    
    Changed password for user logstash_system
    PASSWORD logstash_system = xmgxbjFqBm0xH1JYa6ei
    
    Changed password for user beats_system
    PASSWORD beats_system = CXnV7l0eFvLIntLLqTkm
    
    Changed password for user remote_monitoring_user
    PASSWORD remote_monitoring_user = deHiIa8SljtvcdRvfJna
    
    # elastic的账号密码
    Changed password for user elastic
    PASSWORD elastic = sHvHk04r1LyM30U1h0iL
    ```
    
    **用户自定义密码**
    ```shell
    ./bin/elasticsearch-setup-passwords interactive
    ```
3. 保存上面生成的账号密码，后面需要使用

### 配置Kibana链接Elasticsearch的账号信息
1. 配置kibana.yml，添加
    ```yaml
    elasticsearch.username: "kibana_system"
    ```
    账号是上面生成的。
    如果是zip or tar.gz安装的，配置路径咋/etc/kibana/kibana.yml
   
2. 创建 Kibana keystore
    ```shell
    ./bin/kibana-keystore create
    ```
3. 设置kibana_system对应的密码至Kibana keystore中
    ```shell
    ./bin/kibana-keystore add elasticsearch.password
    ```
    随后提示输入密码，密码为上面生成的密码


4. 重启生效
    
    如果是docker安装，则重启生效。
   
    如果是 .tar.gz安装的，则执行下面的命令，才生效。
    ```shell
    ./bin/kibana
    ```

### 使用账号

**Elasticsearch登录**

方式一：
```text
http://localhost:9200/
登录表单中输入elastic用户的账号、密码
```

方式二：
```text
http://elastic:sHvHk04r1LyM30U1h0iL@localhost:9200/
前缀附带上elastic用户的账号、密码
```


**Kibana登录**
```text
http://localhost:5601
```
输入elastic用户的账号、密码。才有权限操作。这里需要使用elastic用户的账号、密码。

如果输入kibana_system账号、密码，没有操作权限。


### 使用elastic的超级用户添加角色、权限
* [Securing access to Kibana](https://www.elastic.co/guide/en/kibana/7.12/tutorial-secure-access-to-kibana.html)



###　参考
* [Configure security for the Elastic Stack](https://www.elastic.co/guide/en/elasticsearch/reference/7.12/configuring-stack-security.html?blade=kibanasecuritymessage)
* ★★★ [Set up minimal security for Elasticsearch](https://www.elastic.co/guide/en/elasticsearch/reference/7.12/security-minimal-setup.html) ★★★
* [Set up basic security for the Elastic Stack](https://www.elastic.co/guide/en/elasticsearch/reference/7.12/security-basic-setup.html)
* [elasticsearch 6.2.4添加用户密码认证](https://www.cnblogs.com/liangyou666/p/10597093.html)

