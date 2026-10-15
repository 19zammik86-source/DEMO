apt-get install lamp-server
systemctl enable --now httpd2
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html
mkdir -p /var/www/mywebsite
touch /var/www/mywebsite/index.php
cat > /var/www/mywebsite/index.php <<EOF
<?php
phpinfo();
?>
EOF
 cp /etc/httpd2/sites-available/000-default.conf /etc/httpd2/sites-available/mywebsite.conf
 #a2ensite mywebsite
 
