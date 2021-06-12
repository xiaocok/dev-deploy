
#基于Docker部署ETCD集群
#https://www.cnblogs.com/skymyyang/p/10576278.html

#使用Docker部署单节点etcd
#http://www.ebanban.com/?p=519

LOCLA_IP=192.168.33.50

docker run -d \
	--restart=always \
	-v /etc/localtime:/etc/localtime \
	-p 2379:2379 \
    	-p 2380:2380 \
	--name etcd \
	registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:3.2.24 \
	etcd \
	--auto-compaction-retention=1 \
	--max-request-bytes=33554432 \
	--quota-backend-bytes=8589934592 \
	--data-dir=/var/etcd/etcd-data \
	--listen-client-urls http://0.0.0.0:2379 \
	--listen-peer-urls http://0.0.0.0:2380 \
	--initial-advertise-peer-urls http://$LOCLA_IP:2380 \
	--advertise-client-urls http://$LOCLA_IP:2379,http://$LOCLA_IP:2380 \
	--initial-cluster-token etcd-cluster \
	--initial-cluster etcd=http://$LOCLA_IP:2380 \
	--initial-cluster-state new

#quay.io/coreos/etcd:latest
#-v `pwd`/etcd:/var/etcd \

