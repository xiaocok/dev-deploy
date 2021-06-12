
#使用web界面etcd-manager对etcd集群进行管理
#https://www.cnblogs.com/reblue520/p/14382945.html

docker run -d \
	-e ETCD_ADVERTISE_CLIENT_URLS=http://0.0.0.0:2379 \
	-e ETCD_LISTEN_CLIENT_URLS=http://0.0.0.0:2379 \
	-e ETCDCTL_API=3 \
	-p 2379:2379 \
	-p 2380:2380 \
	-p 4001:4001 \
	--name etcdv3.3 \
	quay.io/coreos/etcd:v3.3

# -v `pwd`/default.etcd:/default.etcd
# -e ETCDCTL_API=3
