#!/bin/sh

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
        --url=https://jtanaka.42.fr \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASS}" \
        --admin_email="${WP_ADMIN_MAIL}" \
        --allow-root \
        --path=/var/www/html/wordpress

    wp user create \
        "${WP_USER}" \
        "${WP_USER_MAIL}" \
        --user_pass="${WP_USER_PASS}" \
        --allow-root \
        --path=/var/www/html/wordpress
fi

chown -R www-data:www-data /var/www/html/* \
    && find /var/www/html/ -type d -exec chmod 755 {} + \
    && find /var/www/html/ -type f -exec chmod 644 {} +

# Modify php-fpm config file so that the daemon listens on port 9000
sed -i "s/listen = 127.0.0.1:9000/listen = 9000/g" \
      /etc/php8/php-fpm.d/www.conf
sed -i "s/;listen.owner = nobody/listen.owner = nobody/g" \
      /etc/php8/php-fpm.d/www.conf
sed -i "s/;listen.group = nobody/listen.group = nobody/g" \
      /etc/php8/php-fpm.d/www.conf

echo "HERE IS NOW REACHABLE"

# download & configure wordpress
if [ ! -f "/var/www/wp-config.php" ]; then
      wp core download --path=/var/www

      wp config create  --dbhost=$DB_HOST \
                        --dbname=$DB_NAME \
                        --dbuser=$DB_USER \
                        --dbpass=$DB_PASS \
                        --path=/var/www

      wp core install   --url=$DOMAIN_NAME \
                        --title="Example" \
                        --admin_user=$WP_ADMIN_USER \
                        --admin_password=$WP_ADMIN_PASS \
                        --admin_email=$WP_ADMIN_MAIL \
                        --path=/var/www

      wp user create ${WP_USER} ${WP_USER_MAIL} --role=author --user_pass=$WP_USER_PASS --path=/var/www
fi

echo "WordPress has been installed."

exec "$@"