#!/bin/sh

# Modify php-fpm config file so that the daemon listens on port 9000
sed -i "s/listen = 127.0.0.1:9000/listen = 9000/g" \
      /etc/php8/php-fpm.d/www.conf
sed -i "s/;listen.owner = nobody/listen.owner = nobody/g" \
      /etc/php8/php-fpm.d/www.conf
sed -i "s/;listen.group = nobody/listen.group = nobody/g" \
      /etc/php8/php-fpm.d/www.conf

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