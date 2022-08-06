

# ConfigMap



[TOC]



## ConfigMap基本操作

### ConfigMap注意的事项

1. ConfigMap文件大小限制: 1MB (etcd的限制)
2. ConfigMap必须在Pod引用它之前创建



### 创建ConfigMap

#### 通过 `kubectl create configmap`

根据配置文件、目录或指定的literal-value创建configmap 。

configmap 用来保存一个或多个key/value信息。

- 当基于配置文件创建configmap时，key将默认为文件的基础名称，value默认为文件文本内容。如果基本名称的key无效，则可以指定另一个key。

- 当基于目录创建configmap时，key还是文件的基础名称，目录中每个配置文件名都被设置为key，文件内容设置为value。



##### 语法

```shell
$ configmap NAME [--from-file=[key=]source] [--from-literal=key1=value1] [--dry-run]
```



##### 示例

**根据文件创建**

根据文件创建一个名为my-config的configmap

```shell
kubectl create configmap my-config --from-file=path/to/bar
```

从文件中的key = value对创建一个名为my-config的configmap

```shell
kubectl create configmap my-config --from-file=path/to/bar
```

从env文件创建一个名为my-config的configmap

```shell
kubectl create configmap my-config --from-env-file=path/to/bar.env
```



使用指定的keys创建一个名为my-config的configmap

```shell
kubectl create configmap my-config --from-file=key1=/path/to/bar/file1.txt --from-file=key2=/path/to/bar/file2.txt
```



**根据--from-literal创建**

使用key1 = config1和key2 = config2创建一个名为my-config的configmap

```shell
kubectl create configmap my-config --from-literal=key1=config1 --from-literal=key2=config2
```

```shell
kubectl create configmap nginx-configmap --from-literal=password=123456
```



#### 通过yaml资源配置清单

```shell
kubectl apply -f yaml-configmap.yaml
```

```yaml
apiVersion: v1
kind: List
metadata:
items:
- apiVersion: v1
  data:
    user: "root"
    password: "123456"    
  kind: ConfigMap
  metadata:
    name: yaml-configmap
```



### 创建区别

| 模式           | 表达式                          | key                       | value                                    |
| :------------- | ------------------------------- | ------------------------- | ---------------------------------------- |
| --from-literal | --from-literal=key1=value1      | key1对应挂载至Pod的文件名 | value1对应挂载的文件内容                 |
| file           | --from-file=key1=path/file1.txt | key1对应挂载至Pod的文件名 | file1.txt文件内容为对应挂载的文件内容    |
| dir            | --from-file=path/dir-config     | 没有key1                  | dir-config为挂载的路径。路径下有全部文件 |
| yaml           | data:<br/>    key1: value1      | key1对应挂载至Pod的文件名 | value1对应挂载的文件内容                 |



### 查看ConfigMap

- 通过`kubectl get configmap`查看详细信息

  ```shell
  kubectl get configmap -o yaml
  ```

- 通过`kubectl describe configmap`查看详细信息

  ```shell
  kubectl describe configmap nginx-configmap
  ```

  

### 使用ConfigMap

#### ConfigMap作为volumes存储卷被Pod调用

**创建ConfigMap**

1. 通过文本创建

   ```shell
   kubectl create configmap database-config --from-literal=user=root --from-literal=password=123456
   ```

   查看创建结果

   ```shell
   #  kubectl describe configmap database-config 
   Name:         database-config
   Namespace:    default
   Labels:       <none>
   Annotations:  <none>
   
   Data
   ====
   password:
   ----
   123456
   user:
   ----
   root
   Events:  <none>
   ```

2. 通过文件创建

   ```shell
   kubectl create configmap file-config  --from-file=config=`pwd`/config.ini
   ```

   查看创建结果

   ```shell
   # kubectl describe cm file-config
   Name:         file-config
   Namespace:    default
   Labels:       <none>
   Annotations:  <none>
   
   Data
   ====
   config:
   ----
   user=root
   password=123456
   
   Events:  <none>
   ```

3. 通过文件夹

   ```shell
   kubectl create configmap dir-config --from-file=`pwd`/dir-config
   ```

   查看结果

   ```shell
   # kubectl describe cm dir-config
   Name:         dir-config
   Namespace:    default
   Labels:       <none>
   Annotations:  <none>
   
   Data
   ====
   config1.ini:
   ----
   file=config1
   user=root
   passworl=123456
   
   config2.ini:
   ----
   file=config2
   user=root
   passworl=123456
   
   Events:  <none>
   ```

4. 通过yaml创建

   ```shell
   kubectl apply -f yaml-configmap.yaml
   ```

   yaml文件

   > 注意多行配置文件的输入方式

   ```yaml
   apiVersion: v1
   kind: List              # list可以指定多个对象，这里也可以直接指定ConfigMap,不用list
   metadata:
   items:                  # 指定所有对象
   - apiVersion: v1
     kind: ConfigMap       # 指定类型为ConfigMap
     metadata:
       name: yaml-configmap
     data:
       user: "root"
       password: "123456"
       multiline-config: |
         [Grpc]
         AppId="boss"
         Address="10.1.1.248:10000"
         
         [LogService]
         AppId="boss"
         Address="10.1.1.248:10001"
   ```

   查看创建结果

   ```shell
   kubectl describe cm yaml-configmap 
   Name:         yaml-configmap
   Namespace:    default
   Labels:       <none>
   Annotations:  <none>
   
   Data
   ====
   multiline-config:
   ----
   [Grpc]
   AppId="boss"
   Address="10.1.1.248:10000"
   
   [LogService]
   AppId="boss"
   Address="10.1.1.248:10001"
   
   password:
   ----
   123456
   user:
   ----
   root
   Events:  <none>
   ```



**通过YAML资源定义清单创建Pod并绑定ConfigMap为存储卷**

```shell
kubectl apply -f nginx-pod-configmap-volume.yaml
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod-configmap-volume
spec:
  containers:
    - name: nginx
      image: nginx:1.16
      volumeMounts:
      - name: database-config-volume
        mountPath: /etc/database-config
      - name: file-config-volume
        mountPath: /etc/file-config
      - name: yaml-config-volume
        mountPath: /etc/yaml-config
      - name: dir-config-volume
        mountPath: /etc/dir-config      # 挂载ConfigMap卷的位置
        readOnly: true
  volumes:
    - name: database-config-volume
      configMap:
        name: database-config
    - name: file-config-volume
      configMap:
        name: file-config
    - name: yaml-config-volume
      configMap:
        name: yaml-configmap
    - name: dir-config-volume           # 在pod中直接创建configMap
      configMap:
        name: dir-config                # 定义卷类型为ConfigMap
        items:                          # 选择包含在卷中的条目(文件夹下指定需要挂载的文件，如果未指定则全部都按默认挂载)
        - key: config1.ini              # dir-config的configMap对应的key
          path: config1.ini             # 挂载至容器的path(使用相对路径)
        - key: config2.ini
          path: custom-path/config2.ini
```

```shell
# 查看挂载路径
[root@master ConfigMap]# kubectl exec -it nginx-pod-configmap-volume -- /bin/bash

# 查看database的config
root@nginx-pod-configmap-volume:/# ls -l /etc/database-config/
password
user

root@nginx-pod-configmap-volume:/etc/database-config# cat user
root

root@nginx-pod-configmap-volume:/etc/database-config# cat password
123456

# 查看file挂载的数据
root@nginx-pod-configmap-volume:/etc/file-config# cat config 
user=root
password=123456

# 查看dir
root@nginx-pod-configmap-volume:/etc/dir-config# ls -l /etc/dir-config/
┣━━━ config1.ini
┗━┳━ custom-path
  ┗━━━ config2.ini

root@nginx-pod-configmap-volume:/etc/dir-config# cat config1.ini 
file=config1
user=root
passworl=123456

root@nginx-pod-configmap-volume:/etc/dir-config/custom-path# cat config2.ini 
file=config2
user=root
passworl=123456

# 查看yaml的config
root@nginx-pod-configmap-volume:/etc/yaml-config# ls -l /etc/yaml-config/
multiline-config
password
user

root@nginx-pod-configmap-volume:/etc/yaml-config# cat user 
root

root@nginx-pod-configmap-volume:/etc/yaml-config# cat password 
123456

root@nginx-pod-configmap-volume:/etc/yaml-config# cat multiline-config 
[Grpc]
AppId="boss"
Address="10.1.1.248:10000"

[LogService]
AppId="boss"
Address="10.1.1.248:10001"
```



**查看Pod详细信息，挂载了ConfigMap类型的Volumes**

```shell
kubectl describe pod nginx-pod-configmap
```

```yaml
[root@master ConfigMap]# kubectl describe pod nginx-pod-configmap-volume
Name:         nginx-pod-configmap-volume
Namespace:    default
IPs:
  IP:  10.244.1.18
Containers:
  nginx:
    Container ID:   docker://a916aacefbfa5e5f8253f0217d0e417f34d077f9c84a7370efac9746d3b96e64
    Image:          nginx:1.16
Volumes:
  database-config-volume:
    Type:      ConfigMap (a volume populated by a ConfigMap)
    Name:      database-config
    Optional:  false
  file-config-volume:
    Type:      ConfigMap (a volume populated by a ConfigMap)
    Name:      file-config
    Optional:  false
  yaml-config-volume:
    Type:      ConfigMap (a volume populated by a ConfigMap)
    Name:      yaml-configmap
    Optional:  false
  default-token-fc2qw:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-fc2qw
    Optional:    false
```



#### ConfigMap作为环境变量被Pod调用

**创建ConfigMap**

```shell
kubectl create configmap database-config --from-literal=user=root --from-literal=password=123456
kubectl create configmap env-config --from-literal=LOG_LEVEL=ERROR
```

**创建Pod**

```shell
kubectl apply -f nginx-pod-configmap-env.yaml
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod-configmap-env
spec:
  containers:
    - name: nginx
      image: nginx:1.16
      env:							# 指定环境变量
        - name: DB_USER_CONFIG		# 环境变量的名称
          valueFrom:				# 该环境变量来源于挂载
            configMapKeyRef:		# 相关联的ConfigMap
              name: database-config	# 对应CponfigMap的名称和指定的key
              key: user				# 如果不指定key,则全部都挂载进去
        - name: DB_PASSWORD_CONFIG
          valueFrom:
            configMapKeyRef:
              name: database-config
              key: password
      envFrom:						# 直接指定env挂载，多个
        - configMapRef:
            name: env-config
```

**查看Pod容器的环境变量**

```shell
kubectl exec -it nginx-pod-configmap-env /bin/bash
```

```text
root@nginx-pod-configmap-env:/# env
LOG_LEVEL=ERROR
HOSTNAME=nginx-pod-configmap-env
DB_PASSWORD_CONFIG=123456
DB_USER_CONFIG=root
root@nginx-pod-configmap-env:/# 
```

**查看Pod容器详细信息**

```shell
kubectl describe pod nginx-pod-configmap-env
```

```text
[root@master ConfigMap]# kubectl describe pod nginx-pod-configmap-env
Name:         nginx-pod-configmap-env
Namespace:    default
Containers:
  nginx:
    Container ID:   docker://1962601d90eacdf675aeb312a3e307d580e97036bb33d1a39c10ac2200253bd6
    Image:          nginx:1.16
    Environment Variables from:
      env-config  ConfigMap  Optional: false
    Environment:
      DB_USER_CONFIG:      <set to the key 'user' of config map 'database-config'>      Optional: false
      DB_PASSWORD_CONFIG:  <set to the key 'password' of config map 'database-config'>  Optional: false
Volumes:
  default-token-fc2qw:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-fc2qw
    Optional:    false
```







## 参考

- [Kubernetes - 6.1 Config and Storage - ConfigMap](https://www.toutiao.com/i6799993426491212299/?group_id=6799993426491212299)
- [Kubernetes kubectl create configmap 命令详解](http://docs.kubernetes.org.cn/533.html)
- [k8s实践(八)：ConfigMap and Secret](https://www.toutiao.com/i6799040376674976260/?group_id=6799040376674976260)

