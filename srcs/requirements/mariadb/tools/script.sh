#!/bin/bash
set -e

# Crear carpeta del socket
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# Inicializar base de datos si no existe
if [ ! -d "/var/lib/mysql/${DB_NAME}" ]; then
    echo "Inicializando base de datos..."

    # Crear SQL temporal
    cat << EOF > /tmp/create_db.sql
USE mysql;
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${DB_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    # Ejecutar inicialización
    mysqld --user=mysql --bootstrap < /tmp/create_db.sql
    echo "Base de datos y usuario creados correctamente."
fi

# Asegurar permisos correctos
chown -R mysql:mysql /var/lib/mysql

# Iniciar MariaDB
exec mysqld --user=mysql --console
