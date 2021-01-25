# harbor部署


### 1、下载
github地址：https://github.com/goharbor/harbor<br/>
离线版：https://github.com/goharbor/harbor/releases/download/v2.1.2/harbor-offline-installer-v2.1.2.tgz<br/>
在线版：https://github.com/goharbor/harbor/releases/download/v2.1.2/harbor-online-installer-v2.1.2.tgz<br/>

### 2、创建https证书
* 备注：如果使用http模式，则跳过此步骤

    #### 1. 简单方式
    ```shell
    mkdir -p /data/cert && chmod -R 777 /data/cert && cd /data/cert
    openssl req -x509 -sha256 -nodes -days 3650 -newkey rsa:2048 -keyout harbor.key -out harbor.crt -subj "/CN=hub.com"
    cp ./{harbor.key, harbor.crt} /data/cert
    ```
    
    crt转换为pem(有些需要pem证书)
    ```shell
    openssl x509 -in harbor.crt -out harbor.pem -outform PE
    ```

    #### 2. 官方的方式<br/>
    官方文档：https://goharbor.io/docs/2.1.0/install-config/configure-https/<br/>

    **生成证书颁发机构证书**<br/>
    1. 生成CA证书私钥<br/>
        ```shell
        openssl genrsa -out ca.key 4096
        ```
    
    2. 生成CA证书<br/>
        备注：-subj中的/CN项，填写域名，或者服务器外网IP
        ```shell
        openssl req -x509 -new -nodes -sha512 -days 3650 \
         -subj "/C=CN/ST=Beijing/L=Beijing/O=example/OU=Personal/CN=yourdomain.com" \
         -key ca.key \
         -out ca.crt
        ```

    **生成服务器证书**<br/>
    备注：-subj中的/CN项，填写域名，或者服务器外网IP，与上面的CA证书保持一致
    1. 生成私钥<br/>
        ```shell
        openssl genrsa -out yourdomain.com.key 4096
        ```
    2. 生成证书签名请求（CSR）
        ```shell
        openssl req -sha512 -new \
            -subj "/C=CN/ST=Beijing/L=Beijing/O=example/OU=Personal/CN=yourdomain.com" \
            -key yourdomain.com.key \
            -out yourdomain.com.csr
        ```   
    3. 生成x509 v3扩展文件<br/>
        备注：下面的DNS替换为服务器的域名和IP
        ```shell
        cat > v3.ext <<-EOF
        authorityKeyIdentifier=keyid,issuer
        basicConstraints=CA:FALSE
        keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
        extendedKeyUsage = serverAuth
        subjectAltName = @alt_names
        
        [alt_names]
        DNS.1=yourdomain.com
        DNS.2=yourdomain
        DNS.3=hostname
        EOF
        ```
    4. 使用v3.ext文件为您的Harbor主机生成证书
       ```shell
       openssl x509 -req -sha512 -days 3650 \
           -extfile v3.ext \
           -CA ca.crt -CAkey ca.key -CAcreateserial \
           -in yourdomain.com.csr \
           -out yourdomain.com.crt
       ```
    #### 复制证书
    ```shell
    mkdir -p /data/cert && chmod -R 777 /data/cert && cd /data/cert
    cp ./{yourdomain.com.key, yourdomain.com.crt} /data/cert
    ```

### 3、安装harbor
1. 解压软件包
    ```shell
    tar -zxvf harbor-offline-installer-v2.1.2.tgz
    ```
2. 编辑harbor.yml，修改hostname、https证书路径、admin密码
* 准备
    ```shell
    cd harbor
    cp harbor.yml.back harbor.yml
    ```
* 编辑harbor.yml
    ```yaml
    # 改为域名或者服务器外网IP
    hostname: harbor.com
    
    http:
      portr: 80
    # 如果只使用http, 则这里的https段全部注释
    https:
      port: 443
      # 使用证书的实际路径
      certificate: /data/cert/harbor.crt
      privite_key: /data/cert/harbor.key
    # Web UI的admin账号的密码
    # 密码要求：密码长度在8到20之间且需包含至少一个大写字符，一个小写字符和一个数字。
    # 如果密码不符合规范，登录时，可能报错：Failed to authenticate user, due to error 'Invalid credentials'
    # <<可以暂时不修改密码，部署完成后，Web UI页面修改密码>>
    harbor_admin_password: Harbor12345
    ```
* 生成配置文件
    ```shell
    ./prepare
    ```
* 开始部署
    ```shell
    ./install.sh
    ```

### 4、Web UI 登录harbor
1. 浏览器登录
    ```text
    http://域名或IP:配置的http端口
    https://域名或IP:配置的https端口
    账号：admin
    密码：设置的密码，默认Harbor12345
    ```
2. 修改密码
    ```text
    点击右上角，admin用户，点击修改密码
    密码要求：密码长度在8到20之间且需包含至少一个大写字符，一个小写字符和一个数字
    ```
3. 新建test项目
    ```text
    项目 -> 新建test项目
    项目设置为public，则用户不需要认证即可拉取镜像
    ```
### 5、推送镜像至仓库
备注：需要设置仓库地址、需要登录仓库
1. 配置镜像仓库地址<br/>
    域名或者服务器IP
    ```shell
    vim /etc/docker/daemon.json
    { 
        "insecure-registries": ["域名/服务器IP:端口"]
    }
    ```

2. 重启docker服务使配置生效
    ```shell
    systemctl daemon-reload && systemctl restart docker
    ```

3. 登录仓库
    ```shell
    docker login 域名/服务器IP:端口 -u admin -p Harbor12345
    ```
    
    安装证书：<br/>
    如果提示证书异常，则可以安装证书
    ```shell
    # 拷贝证书文件到信任证书
    cp harbor.crt /etc/pki/ca-trust/source/anchors/

    # 更新信任证书
    update-ca-trust
    ```
    
4. 推送镜像<br/>
    仓库地址: 域名/服务器IP:端口<br/>
    新建的项目: test<br/>
    镜像：hello-world<br/>
    ```shell
    docker pull hello-world
    docker tag hello-world 域名/服务器IP:端口/test/hello-world:latest
    docker push 域名/服务器IP:端口/test/hello-world:latest
    ```

### 6、使用仓库的容器
1. 添加仓库
    ```shell
    vim /etc/docker/daemon.json
    {
      "insecure-registries": ["域名/服务器IP:端口"]
    }
    ```
2. 重启docker服务使配置生效
    ```shell
    systemctl daemon-reload && systemctl restart docker
    ```
3. 拉取镜像
    ```shell
    docker pull 域名/服务器IP:端口/test/hello-world:latest
    ```

### 附录
#### 重置harbor登录密码
* 如果安装时，修改了admin登录密码，并且安装后，一直登录不了，提示密码错误，则可以重置密码。
* 卸载重新重新安装也不可以，原因是没有删除harbor的数据，harbor数据在/data/目录下边，如果真要重新安装需要将这个也删除，备份或者迁移，请使用这个目录的数据。

#### 具体步骤：
1. 进入[harbor-db]容器内部
    ```shell
    docker exec -it harbor-db /bin/bash
    ``` 
    
2. 进入postgresql命令行
    ```shell
   psql -h postgresql -d postgres -U postgres          #这要输入默认密码：root123。
   psql -U postgres -d postgres -h 127.0.0.1 -p 5432   #或者用这个可以不输入密码。
    ```

3. 切换到harbor所在的数据库
    ```shell
    \c registry
    ```

4. 查看harbor_user表
    ```shell
    select * from harbor_user;
    ```

5. 例如修改admin的密码，修改为初始化密码 Harbor12345 ，修改好了之后再可以从web ui上再改一次。
    ```shell
    update harbor_user set password='a71a7d0df981a61cbb53a97ed8d78f3e',salt='ah3fdh5b7yxepalg9z45bu8zb36sszmr' where username='admin';
    ```

6. 退出 \q 退出postgresql，exit退出容器。
    ```shell
    \q
    exit
    ```

7. 完成后通过WEB UI，就可以使用admin 、Harbor12345 这个密码登录了，记得修改这个默认密码哦，避免安全问题。
