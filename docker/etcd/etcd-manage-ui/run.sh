
#https://blog.csdn.net/weixin_34326179/article/details/88708506
#https://www.cnblogs.com/reblue520/p/14382945.html
#https://github.com/shiguanghuxian/etcd-manage
#https://github.com/shiguanghuxian/docker-compose/tree/master/etcd33

docker run -d \
	--name etcd-manage \
	-v `pwd`/cfg.toml:/app/config/cfg.toml \
	-p 10280:10280 \
	shiguanghuxian/etcd-manage:1

