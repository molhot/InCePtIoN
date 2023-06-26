FROM alpine:3.16

RUN apk update && apk upgrade && \
			apk add --no-cache \
			php8 \
			php8-fpm \
			php8-mysqli \
		 	php8-json \
			php8-curl \
    		php8-dom \
			php8-exif \
			php8-fileinfo \ 
			php8-mbstring \
    		php8-openssl \
			php8-xml \
			php8-zip \
			php8-cli \
			php8-phar \
			mariadb-client \
			wget \
			ranger

RUN wget \
	https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www/html
COPY configure.sh .

RUN 		chmod +x configure.sh

ENTRYPOINT	["sh", "configure.sh"]

CMD ["/usr/sbin/php-fpm8", "-F"]