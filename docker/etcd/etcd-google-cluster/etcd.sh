
#基于Docker部署ETCD集群
#https://www.cnblogs.com/skymyyang/p/10576278.html

#使用Docker部署单节点etcd
#http://www.ebanban.com/?p=519

#etcd-s1
ETCD_S1_IP=192.168.33.50
ETCD_S1_CLIENT_PORT=23791
ETCD_S1_PEER_PORT=23801

#etcd-s2
ETCD_S2_IP=192.168.33.50
ETCD_S2_CLIENT_PORT=23792
ETCD_S2_PEER_PORT=23802

#etcd-s3
ETCD_S3_IP=192.168.33.50
ETCD_S3_CLIENT_PORT=23793
ETCD_S3_PEER_PORT=23803

#内存大小
max_request_bytes=10485760
quota_backend_bytes=100000000


#etcd-s1
docker run -d \
	-v /etc/localtime:/etc/localtime \
	-p $ETCD_S1_CLIENT_PORT:2379 \
	-p $ETCD_S1_PEER_PORT:2380 \
	--name etcd-s1 \
	registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:3.2.24 \
	etcd \
	--name etcd-s1 \
	--auto-compaction-retention=1 \
	--max-request-bytes=$max_request_bytes \
	--quota-backend-bytes=$quota_backend_bytes \
	--data-dir=/var/etcd/etcd-data \
	--listen-client-urls http://0.0.0.0:2379 \
	--listen-peer-urls http://0.0.0.0:2380 \
	--initial-advertise-peer-urls http://$ETCD_S1_IP:$ETCD_S1_PEER_PORT \
	--advertise-client-urls http://$ETCD_S1_IP:$ETCD_S1_CLIENT_PORT,http://$ETCD_S1_IP:$ETCD_S1_PEER_PORT \
	--initial-cluster-token etcd-cluster \
	--initial-cluster etcd-s1=http://$ETCD_S1_IP:$ETCD_S1_PEER_PORT,etcd-s2=http://$ETCD_S2_IP:$ETCD_S2_PEER_PORT,etcd-s3=http://$ETCD_S3_IP:$ETCD_S3_PEER_PORT \
	--initial-cluster-state new

#-v `pwd`/etcd-s1:/var/etcd \


#etcd-s2
docker run -d \
	-v /etc/localtime:/etc/localtime \
	-p $ETCD_S2_CLIENT_PORT:2379 \
	-p $ETCD_S2_PEER_PORT:2380 \
	--name etcd-s2 \
	registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:3.2.24 \
	etcd \
	--name etcd-s2 \
	--auto-compaction-retention=1 \
	--max-request-bytes=$max_request_bytes \
        --quota-backend-bytes=$quota_backend_bytes \
	--data-dir=/var/etcd/etcd-data \
	--listen-client-urls http://0.0.0.0:2379 \
	--listen-peer-urls http://0.0.0.0:2380 \
	--initial-advertise-peer-urls http://$ETCD_S2_IP:$ETCD_S2_PEER_PORT \
	--advertise-client-urls http://$ETCD_S2_IP:$ETCD_S2_CLIENT_PORT,http://$ETCD_S2_IP:$ETCD_S2_PEER_PORT \
	--initial-cluster-token etcd-cluster \
	--initial-cluster etcd-s1=http://$ETCD_S1_IP:$ETCD_S1_PEER_PORT,etcd-s2=http://$ETCD_S2_IP:$ETCD_S2_PEER_PORT,etcd-s3=http://$ETCD_S3_IP:$ETCD_S3_PEER_PORT \
	--initial-cluster-state new

#-v `pwd`/etcd-s2:/var/etcd \



#etcd-s3
docker run -d \
	-v /etc/localtime:/etc/localtime \
	-p $ETCD_S3_CLIENT_PORT:2379 \
	-p $ETCD_S3_PEER_PORT:2380 \
	--name etcd-s3 \
	registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:3.2.24 \
	etcd \
	--name etcd-s3 \
	--auto-compaction-retention=1 \
	--max-request-bytes=$max_request_bytes \
        --quota-backend-bytes=$quota_backend_bytes \
	--data-dir=/var/etcd/etcd-data \
	--listen-client-urls http://0.0.0.0:2379 \
	--listen-peer-urls http://0.0.0.0:2380 \
	--initial-advertise-peer-urls http://$ETCD_S3_IP:$ETCD_S3_PEER_PORT \
	--advertise-client-urls http://$ETCD_S3_IP:$ETCD_S3_CLIENT_PORT,http://$ETCD_S3_IP:$ETCD_S3_PEER_PORT \
	--initial-cluster-token etcd-cluster \
	--initial-cluster etcd-s1=http://$ETCD_S1_IP:$ETCD_S1_PEER_PORT,etcd-s2=http://$ETCD_S2_IP:$ETCD_S2_PEER_PORT,etcd-s3=http://$ETCD_S3_IP:$ETCD_S3_PEER_PORT \
	--initial-cluster-state new


#-v `pwd`/etcd-s3:/var/etcd \
#--restart=always \


