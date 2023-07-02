#!/bin/bash

exec_helper()
{
    exec php-fpm7.3 --nodaemonize
}

# wordpress
if ! wp core is-installed --allow-root --path=/var/www/html/wordpress &> /dev/null ; then
    echo "Install WordPress"
    wp core download --locale=ja --allow-root --path=/var/www/html/wordpress

    wp config create \
        --force \
        --dbname="${WP_DB_NAME}" \
        --dbuser="${WP_DB_USER}" \
        --dbpass="${WP_DB_PASSWORD}" \
        --dbhost="${WP_DB_HOST}" \
        --locale=ja \
        --allow-root \
        --path=/var/www/html/wordpress

    wp core install \
        --url=https://satushi.42.fr \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --allow-root \
        --path=/var/www/html/wordpress

    wp user create \
        "${WP_USER}" \
        "${WP_EMAIL}" \
        --user_pass="${WP_PASSWORD}" \
        --allow-root \
        --path=/var/www/html/wordpress
fi

chown -R www-data:www-data /var/www/html/* \
    && find /var/www/html/ -type d -exec chmod 755 {} + \
    && find /var/www/html/ -type f -exec chmod 644 {} +

# php-fpm

sed -i "s|listen = /run/php/php7.3-fpm.sock|listen = 9000|g" /etc/php/7.3/fpm/pool.d/www.conf
sed -i "s|skip-networking|# skip-networking|g" /etc/php/7.3/fpm/pool.d/www.conf

# PIDファイル
mkdir -p /run/php

echo "start php-fpm7.3"
echo "ENTER RETURN"

exec_helper