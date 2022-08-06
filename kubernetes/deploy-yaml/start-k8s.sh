
docker start `docker ps -a |grep k8s_ | grep Exited|awk '{print $1}'`

