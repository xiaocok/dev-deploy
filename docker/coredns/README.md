

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
   ```

   

### 参考

- [CoreDNS](https://github.com/coredns/coredns)

