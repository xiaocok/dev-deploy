

1. 验证dns解析

   > coredns未配置解析，因此无法解析到www.baidu.com 和 www.example.com

   ```shell
   dig @127.0.0.1 -p 53 www.example.com
   
   ; <<>> DiG 9.18.1-1ubuntu1.3-Ubuntu <<>> @127.0.0.1 -p 53 www.example.com
   ; (1 server found)
   ;; global options: +cmd
   ;; Got answer:
   ;; ->>HEADER<<- opcode: QUERY, status: SERVFAIL, id: 13351
   ;; flags: qr rd; QUERY: 1, ANSWER: 0, AUTHORITY: 0, ADDITIONAL: 1
   ;; WARNING: recursion requested but not available
   
   ;; OPT PSEUDOSECTION:
   ; EDNS: version: 0, flags:; udp: 1232
   ; COOKIE: 2b6b21cf87889cc5 (echoed)
   ;; QUESTION SECTION:
   ;www.example.com.               IN      A
   
   ;; Query time: 0 msec
   ;; SERVER: 127.0.0.1#53(127.0.0.1) (UDP)
   ;; WHEN: Sat Feb 25 23:36:43 CST 2023
   ;; MSG SIZE  rcvd: 56

2. 使用ETCD命令行注册添加域名解析

   ```shell
   docker run -it --rm \
       --network default-net \
       --env ALLOW_NONE_AUTHENTICATION=yes \
       bitnami/etcd:3.5.7 etcdctl --endpoints http://etcd:2379 put /skydns/com/example/www '{"host":"192.168.11.11","ttl":60}'
   
   
   etcd 14:15:49.31
   etcd 14:15:49.31 Welcome to the Bitnami etcd container
   etcd 14:15:49.31 Subscribe to project updates by watching https://github.com/bitnami/containers
   etcd 14:15:49.32 Submit issues and feature requests at https://github.com/bitnami/containers/issues
   etcd 14:15:49.32
   
   OK
   ```

3. 使用ETCD命令查询

   ```shell
   docker run -it --rm \
       --network default-net \
       --env ALLOW_NONE_AUTHENTICATION=yes \
       bitnami/etcd:3.5.7 etcdctl --endpoints http://etcd:2379 get /skydns/com/example/www
       
       
   etcd 14:15:54.93
   etcd 14:15:54.93 Welcome to the Bitnami etcd container
   etcd 14:15:54.93 Subscribe to project updates by watching https://github.com/bitnami/containers
   etcd 14:15:54.94 Submit issues and feature requests at https://github.com/bitnami/containers/issues
   etcd 14:15:54.94
   
   /skydns/com/example/www
   {"host":"192.168.11.11","ttl":60}
   ```

4. 使用dns解析

   > 解析IP为192.168.11.11

   ```shell
   dig @127.0.0.1 -p 53 www.example.com
   
   ; <<>> DiG 9.18.1-1ubuntu1.3-Ubuntu <<>> @127.0.0.1 -p 53 www.example.com
   ; (1 server found)
   ;; global options: +cmd
   ;; Got answer:
   ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 13944
   ;; flags: qr aa rd; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1
   ;; WARNING: recursion requested but not available
   
   ;; OPT PSEUDOSECTION:
   ; EDNS: version: 0, flags:; udp: 1232
   ; COOKIE: 444d3c2fcb70b4c6 (echoed)
   ;; QUESTION SECTION:
   ;www.example.com.               IN      A
   
   ;; ANSWER SECTION:
   www.example.com.        30      IN      A       192.168.11.11
   
   ;; Query time: 10 msec
   ;; SERVER: 127.0.0.1#53(127.0.0.1) (UDP)
   ;; WHEN: Sat Feb 25 23:39:19 CST 2023
   ;; MSG SIZE  rcvd: 87
   ```

5. 查询全部键值

   ```shell
   docker run -it --rm \
       --network default-net \
       --env ALLOW_NONE_AUTHENTICATION=yes \
       bitnami/etcd:3.5.7 etcdctl --endpoints http://etcd:2379 get / --prefix
       
       
   etcd 14:18:13.80
   etcd 14:18:13.81 Welcome to the Bitnami etcd container
   etcd 14:18:13.81 Subscribe to project updates by watching https://github.com/bitnami/containers
   etcd 14:18:13.81 Submit issues and feature requests at https://github.com/bitnami/containers/issues
   etcd 14:18:13.82
   
   /skydns/com/example/www
   {"host":"192.168.11.11","ttl":60} 
   ```

6. 设置反向解析

   ```shell
   docker run -it --rm \
       --network default-net \
       --env ALLOW_NONE_AUTHENTICATION=yes \
       bitnami/etcd:3.5.7 etcdctl --endpoints http://etcd:2379 put /skydns/arpa/in-addr/192/168/11/11 '{"host":"www.example.com","ttl":60}'
       
       
   # 查询全部结果
   /skydns/arpa/in-addr/192/168/11/11
   {"host":"www.example.com","ttl":60}
   /skydns/com/example/www
   {"host":"192.168.11.11","ttl":60}
   ```

7. 反向解析

   **dig反向解析**

   > dig -x 待解析的IP @DNS服务器

   ```shell
   # dig @127.0.0.1 -p 53 -x 192.168.11.11
   
   ; <<>> DiG 9.18.1-1ubuntu1.3-Ubuntu <<>> @127.0.0.1 -p 53 -x 192.168.11.11
   ; (1 server found)
   ;; global options: +cmd
   ;; Got answer:
   ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 60653
   ;; flags: qr aa rd; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1
   ;; WARNING: recursion requested but not available
   
   ;; OPT PSEUDOSECTION:
   ; EDNS: version: 0, flags:; udp: 1232
   ; COOKIE: 66f64a984650d714 (echoed)
   ;; QUESTION SECTION:
   ;11.11.168.192.in-addr.arpa.    IN      PTR
   
   ;; ANSWER SECTION:
   11.11.168.192.in-addr.arpa. 30  IN      PTR     www.example.com.
   
   ;; Query time: 0 msec
   ;; SERVER: 127.0.0.1#53(127.0.0.1) (UDP)
   ;; WHEN: Sun Feb 26 00:13:24 CST 2023
   ;; MSG SIZE  rcvd: 122
   ```

   **使用nslookup命令反向解析**

   > nslookup -ty=ptr ip [dnsserver]

   - 非交互模式: `nslookup -ty=类型 name`
   - 交互模式: `set ty=类型`

   `-type` 简写为和 `-ty`，其在不指定类型的情况下默认查询类型为 **A**

   

   type可以是以下这些类型：

   - A 地址记录（直接查询默认类型）
   - AAAA 地址记录
   - AFSDB Andrew文件系统数据库服务器记录
   - ATMA ATM地址记录
   - CNAME 别名记录
   - HINFO 硬件配置记录，包括CPU、操作系统信息
   - ISDN 域名对应的ISDN号码
   - MB 存放指定邮箱的服务器
   - MG 邮件组记录
   - MINFO 邮件组和邮箱的信息记录
   - MR 改名的邮箱记录
   - MX 邮件服务器记录
   - NS 名字服务器记录
   - **`PTR 反向记录`**
   - RP 负责人记录
   - RT 路由穿透记录
   - SRV TCP服务器信息记录
   - TXT 域名对应的文本信息
   - X25 域名对应的X.25地址记录

   ```shell
   # nslookup 192.168.11.11 127.0.0.1
   11.11.168.192.in-addr.arpa      name = www.example.com.
   
   
   # nslookup -ty=ptr 192.168.11.11 127.0.0.1
   Server:         127.0.0.1
   Address:        127.0.0.1#53
   
   11.11.168.192.in-addr.arpa      name = www.example.com.
   ```

   

### 参考

- [bitnami/etcd](https://hub.docker.com/r/bitnami/etcd)
- [docker-compose](https://github.com/docker/compose/releases)
- [coredns etcd](https://blog.csdn.net/chenqioulin/article/details/123907784)
- [CoreDNS](https://github.com/coredns/coredns)

