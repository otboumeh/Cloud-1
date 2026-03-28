#!/bin/bash

# 1. Leer Secretos
SQL_PASSWORD=$(cat /run/secrets/db_password)
ADMIN_PASSWORD=$(cat /run/secrets/credentials)
USER1_PASS=$(cat /run/secrets/user1_password)

# 2. Esperar a MariaDB (Local)

echo "Esperando conexión con el contenedor MariaDB..."
while ! mariadb -h"mariadb" -u"$SQL_USER" -p"$SQL_PASSWORD" -e "SELECT 1;" >/dev/null 2>&1; do
    sleep 2
done
echo "¡MariaDB conectada!"

# 3. Instalación
cd /var/www/wordpress

if [ ! -f wp-config.php ]; then
    wp core download --allow-root

    # Configuración apuntando al contenedor local
    wp config create \
        --dbname="$SQL_DATABASE" \
        --dbuser="$SQL_USER" \
        --dbpass="$SQL_PASSWORD" \
        --dbhost="mariadb" \
        --allow-root

    wp core install \
        --url="$DOMAIN_NAME" \
        --title="$SITE_TITLE" \
        --admin_user="$ADMIN_USER" \
        --admin_password="$ADMIN_PASSWORD" \
        --admin_email="$ADMIN_EMAIL" \
        --allow-root

    wp user create "$USER1_LOGIN" "$USER1_EMAIL" --role=author --user_pass="$USER1_PASS" --allow-root
    echo "WordPress instalado correctamente."
fi

exec /usr/sbin/php-fpm8.2 -F
