
#https://www.cnblogs.com/hatlonely/p/11945491.html
#https://github.com/soyking/e3w
#https://github.com/hpifu/docker-e3w

docker run -d \
	-p 8090:8080 \
	-v `pwd`/config.ini:/app/conf/config.default.ini \
	--name e3w \
	soyking/e3w:latest
