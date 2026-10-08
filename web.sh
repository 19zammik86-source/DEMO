apt-get install -y lamp-server

mount /dev/sr0 /mnt || true

cp /mnt/web/index.php /var/www/html/
cp /mnt/web/logo.png /var/www/html/

sed -i "s/\$username = \"user\";/\$username = \"web1\";/" /var/www/html/index.php
sed -i "s/\$password = \"password\";/\$password = \"P@ssw0rd\";/" /var/www/html/index.php
sed -i "s/\$dbname = \"db\";/\$dbname = \"webdb\";/" /var/www/html/index.php

systemctl enable --now mariadb

mariadb -u root <<EOF
CREATE DATABASE IF NOT EXISTS webdb;
CREATE USER IF NOT EXISTS 'web1'@'localhost' IDENTIFIED BY 'P@ssw0rd';
GRANT ALL PRIVILEGES ON webdb.* TO 'web1'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

mariadb -u web1 -p'P@ssw0rd' webdb < /mnt/web/dump.sql

mariadb -u root <<EOF
USE webdb;
SHOW TABLES;
EOF

systemctl enable --now httpd2
