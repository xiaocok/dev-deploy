

要在Docker中设置RabbitMQ集群，您可以使用`docker-compose`来定义和启动多个容器。

执行下面命令，用于创建一个有三个节点的RabbitMQ集群：

```shell
docker-compose up -d
```



在这个配置中，我们定义了三个服务：`rabbitmq1`、`rabbitmq2`和`rabbitmq3`，它们都使用相同的镜像`rabbitmq:3-management`，带有RabbitMQ管理插件。我们设置了Erlang Cookie以便节点能够彼此识别，并且为每个节点的数据卷进行了定义。



一旦启动RabbitMQ的后台启动所有服务。你可以通过访问`http://localhost:15672`, `http://localhost:15673`, 和 `http://localhost:15674`来连接到RabbitMQ管理界面（各自对应于一个节点）。默认用户和密码都是`guest`。

要加入更多的RabbitMQ节点，只需按照上面的模式添加更多服务即可。记得更新Erlang Cookie和端口映射。



```shell
# sudo firewall-cmd --permanent --add-port=5672/tcp
# sudo firewall-cmd --permanent --add-port=15672/tcp

# sudo firewall-cmd --permanent --add-port=5673/tcp
# sudo firewall-cmd --permanent --add-port=15673/tcp

# sudo firewall-cmd --permanent --add-port=5674/tcp
# sudo firewall-cmd --permanent --add-port=15674/tcp

# sudo firewall-cmd --reload
```





访问Web：

rabbitmq1 http://localhost:15672/

rabbitmq2 http://localhost:15673/

rabbitmq3 http://localhost:15674/

账号/密码(默认)：guest/guest





单节点

[Docker 下安装并配置 RabbitMQ 以允许远程访问](https://blog.csdn.net/csdn122345/article/details/145685531)

```shell
docker run -d --name rabbitmq -p 5675:5672 -p 15675:15672 rabbitmq:management

docker exec -it rabbitmq rabbitmqctl add_user rabbitmq rabbitmq
docker exec -it rabbitmq rabbitmqctl set_user_tags rabbitmq adminstrator
docker exec -it rabbitmq rabbitmqctl set_permissions -p / rabbitmq ".*" ".*" ".*"
docker exec -it rabbitmq rabbitmqctl add_vhost myvhost

docker exec -it rabbitmq rabbitmqctl add_vhost myvhost
docker exec -it rabbitmq rabbitmqctl set_permissions -p myvhost rabbitmq ".*" ".*" ".*"


```



```shell
docker run -d \
--name rabbitmq \
-p 5672:5672 \      # AMQP协议端口
-p 15672:15672 \    # 管理界面端口
-e RABBITMQ_DEFAULT_VHOST=/dev \
-e RABBITMQ_DEFAULT_USER=admin \     # 自定义用户名
-e RABBITMQ_DEFAULT_PASS=admin123 \  # 自定义密码
--restart=always \
rabbitmq:management
```

