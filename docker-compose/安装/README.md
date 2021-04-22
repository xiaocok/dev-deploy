
# Docker-Compose安装

### 下载最新版

    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

### 添加执行权限

    sudo chmod +x /usr/local/bin/docker-compose

### 添加软连接

    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

### 检验安装结果

    $ docker-compose --version

#### 参考
* [Install Docker Compose](https://docs.docker.com/compose/install/)