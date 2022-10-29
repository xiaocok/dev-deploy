
docker run \
	--name consul \
	-p 53:53 \
	-p 8300:8300 \
	-p 8400:8400 \
	-p 8500:8500 \
	-d consul:1.9.5 agent -server -ui -data-dir /tmp/data-dir -bootstrap-expect 1 -client 0.0.0.0

#web 访问
#http://IP:8500/
