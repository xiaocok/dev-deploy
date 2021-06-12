
#http://kailing.pub/article/index/arcid/253.html
#https://github.com/nikfoundas/etcd-viewer

docker run -d \
	-p 8100:8080 \
	--name etcd-viewer \
	nikfoundas/etcd-viewer
