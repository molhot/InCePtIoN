FROM php:7.4-fpm

RUN apt-get update && \
	apt-get install -y \
	php \
	php-fpm \
	php-mbstring \
	php-pdo\
	php-mysqlnd \
	mariadb-cliend \
	sendmail \
	curl \
	libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
	vim \
	&& docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd zip mysqli pdo_mysql

RUN curl -O \
	https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www/html
COPY configure.sh /tmp/configure.sh

CMD [ "bash", "/tmp/configure.sh"]