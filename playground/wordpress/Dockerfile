FROM debian:buster

RUN apt-get update \
  && apt-get install -y \
  git \
  wget \
  php \
  php-fpm \
  php-mbstring \
  php-pdo \
  php-mysqlnd \
  mariadb-client \
  curl \
  vim \
  sendmail

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
  chmod +x wp-cli.phar && \
  mv wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www/html
COPY configure.sh .

CMD ["bash", "configure.sh"]