
# Docker加速

### 加速地址
* 官方加速
  
    https://registry.docker-cn.com


* 中科大加速

    https://docker.mirrors.ustc.edu.cn


* 网易加速

    http://hub-mirror.c.163.com


* DaoCloud加速

    加速器页面：
        
    https://www.daocloud.io/mirror

    找到对应的加速器地址：
    
    http://xxxxx.m.daocloud.io    


* 阿里云加速
  
    https://xxxxx.mirror.aliyuncs.com
    
    需要设置阿里云分配的实际地址


### 修改docker的配置项
设置指定的加速地址

    vim /etc/docker/daemon.json
    {
        "registry-mirrors": [
            "https://docker.mirrors.ustc.edu.cn",
            "https://registry.docker-cn.com",
            "http://hub-mirror.c.163.com",
            "https://xxxxx.mirror.aliyuncs.com",
            "http://xxxxx.m.daocloud.io"
        ]
    }

重启docker

    systemctl restart docker