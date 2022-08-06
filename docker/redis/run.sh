

#docker run --name redis -p 6379:6379 -d redis

docker run \
	-p 6379:6379 \
	--name redis \
	-d redis redis-server --appendonly yes --requirepass 123456

#-v `pwd`/redis.conf:/etc/redis/redis.conf \
#-v `pwd`/data:/data \
#-d redis redis-server /etc/redis/redis.conf --appendonly yes --requirepass 123456
