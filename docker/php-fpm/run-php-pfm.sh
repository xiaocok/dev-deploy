docker run -d \
	-p 9000:9000 \
	--name php-fpm \
	--restart=always \
	-v /www:/usr/share/nginx/www \
	php:7.4.18-fpm
