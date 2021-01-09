# Prometheus

### 配置AlertManager
* 编辑配置文件<br/>
    vim alertmanager/alertmanager.yml
    ```yaml
    global:
      # 配置邮件发送信息，例如163邮箱
      smtp_smarthost: 'smtp.163.com:465'
      # 邮件的发送者
      smtp_from: 'sender@163.com'
      # 邮件登录用户名
      smtp_auth_username: 'sender@163.com'
      # 邮件的认证码，不是密码
      smtp_auth_password: 'password'
      smtp_require_tls: false
    # 邮件的默认接收者
    receivers:
    - name: 'default'
      email_configs:
      # 邮件的接收者
      - to: 'receiver@163.com'
        send_resolved: true
      # 钉钉发送组件
      webhook_configs:
      # url为timonwong/prometheus-webhook-dingtalk的本地地址
      - url: http://dingtalk:8060/dingtalk/webhook/send
        send_resolved: true
    ```

### dingtalk配置
* 编辑配置文件
    vim dingtalk/config.yml
    ```yaml
    targets:
      webhook:
        # 钉钉的发送地址，钉钉的机器人处获取
        url: https://oapi.dingtalk.com/robot/send?access_token=
        # 签名，钉钉的机器人处获取
        secret: 
    ```

### grafana配置
* 设置默认登录账号
    vim docker-compose.yml
    ```yaml
    grafana:
        image: grafana/grafana:7.1.5
        restart: always
        ports:
            #grafana的web访问端口
            - "3000:3000"
        environment:
            # 登录用户名、密码
            - "GF_SECURITY_ADMIN_USER=admin"
            - "GF_SECURITY_ADMIN_PASSWORD=admin"
    ```
    
### prometheus配置
* 采集规则
    vim prometheus/conf/prometheus.yml
    ```yaml
    # alertmanager告警配置
    alerting:
      alertmanagers:
      - static_configs:
        - targets:
           - 'alertmanager:9093'
    
    # 告警配置文件路径
    rule_files:
      - "/etc/prometheus/rules/rule.yaml"
    
    # 采集配置
    scrape_configs:
      # prometheus自身采集
      - job_name: 'prometheus'
        static_configs:
        - targets: ['localhost:9090']
      # 节点采集
      - job_name: 'node-cluster'
        static_configs:
          - targets:
            - 'node-exporter:9100'
      # mysql采集
      - job_name: 'mysql_exporter'
        static_configs:
          - targets: 
            - 'mysql_exporter:9104'
      # redis采集
      - job_name: "redis_exporter"
        static_configs:
          - targets:
            - 'redis_exporter:9121'
    ```
* 告警规则<br/>
    根据实际告警要求调整<br/>
    vim prometheus/conf/rules/rule.yaml
    
