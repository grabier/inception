#!/bin/bash

echo "Esperando a que MariaDB esté lista..."
until mysqladmin ping -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASSWORD" --silent; do
    sleep 2
done
echo "MariaDB disponible, continuando."

if [ ! -f "/var/www/wp-config.php" ]; then
    echo "Instalando WordPress..."
    wp core download --allow-root --path='/var/www'

    wp config create --allow-root \
        --dbname="$DB_NAME" \
        --dbuser="$DB_USER" \
        --dbpass="$DB_PASSWORD" \
        --dbhost="mariadb:3306" \
        --path='/var/www'

    wp core install --allow-root \
        --url="$WP_URL" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --path='/var/www'

    wp user create "$WP_USER" "$WP_USER_EMAIL" \
        --role=author --user_pass="$WP_USER_PASSWORD" \
        --allow-root --path='/var/www'
else
    echo "WordPress ya está instalado, saltando instalación."
fi

chown -R www-data:www-data /var/www
chmod -R 755 /var/www

exec /usr/sbin/php-fpm8.2 -F

