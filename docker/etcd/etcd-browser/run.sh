
#https://blog.csdn.net/fgf00/article/details/80263707
#https://www.github.com/buddho-io/etcd-browser
#https://github.com/henszey/etcd-browser
#https://hub.docker.com/r/buddho/etcd-browser


docker run -d \
	--name etcd-browser \
	-p 0.0.0.0:8000:8000 \
	--env ETCD_HOST=192.168.33.50 \
	--env ETCD_PORT=23791 \
	buddho/etcd-browser


# --env ETCD_HOST=192.168.33.50
# --env ETCD_PORT=4001 \
# --env SERVER_PORT=23791 \
# --env AUTH_USER= \
# --env AUTH_PASS= \

