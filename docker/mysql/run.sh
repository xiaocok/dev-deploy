
docker run --name mysql \
	-p 3306:3306 \
	-e MYSQL_ROOT_PASSWORD=root \
	-d mysql:5.7.34



#允许远程访问
#首先要进入容器内部
#docker exec -it 容器名或容器ID

#进入mysql
#mysql -u root -p

#授权
#密码是上面设置的密码
#GRANT ALL PRIVILEGES ON *.* TO root@"%" IDENTIFIED BY "root";
#flush privileges;

#退出
#exit
#exit
#第一个exit退出mysql
#第二个exit退出容器的bash
