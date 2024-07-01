
docker run \
	-d \
	--restart=always \
	--name postgres \
	-v /opt/pgsql/data:/var/lib/postgresql/data \
	-e POSTGRES_PASSWORD=123456 \
	-p 5432:5432 \
	postgres


# 允许外部访问
#修改/var/lib/postgresql/data/pg_hba.conf文件，在文件最后追加
#host all all 0.0.0.0/0 md5

# 使用命令
# docker exec -it postgresql /bin/bash
# echo "host all all 0.0.0.0/0 md5" >> pg_hba.conf
# exit
# docker restart postgresql