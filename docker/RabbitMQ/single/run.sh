
#https://hub.docker.com/_/rabbitmq
#默认账号、密码：guest

docker run -d \
	--name rabbitmq \
	-p 5672:5672 \
	-p 15672:15672 \
	-e RABBITMQ_DEFAULT_USER=guest \
	-e RABBITMQ_DEFAULT_PASS=guest \
	rabbitmq:3.8.17-management
