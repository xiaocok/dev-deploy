
docker run -d \
	--name nginx \
	-p 80:80 \
	--restart=always \
	--link php-fpm:php-fpm \
	-v `pwd`/nginx.conf:/etc/nginx/nginx.conf \
	-v `pwd`/conf.d:/etc/nginx/conf.d \
	-v /www:/usr/share/nginx/www \
	nginx:1.20.0

# -v `pwd`/nginx.conf:/etc/nginx/nginx.conf \
# -v `pwd`/conf.d:/etc/nginx/conf.d \
# --privileged=true \
