#mkdir -p /var/www/mysite.com/public_html
#chown -R apache:apache /var/www/mysite.com
   #chmod -R 755 /var/www/mysite.com
   echo "<h1>Сайт mysite.com работает!</h1>" > /var/www/mysite.com/public_html/index.html
   touch /etc/httpd/conf.d/mysite.com.conf
   cat > /etc/httpd/conf.d/mysite.com.conf <<EOF
   <VirtualHost *:80>
       ServerName mysite.com
       ServerAlias www.mysite.com
       DocumentRoot /var/www/mysite.com/public_html

       <Directory /var/www/mysite.com/public_html>
           Options Indexes FollowSymLinks
           AllowOverride All
           Require all granted
       </Directory>

       ErrorLog /var/log/httpd/mysite.com_error.log
       CustomLog /var/log/httpd/mysite.com_access.log combined
   </VirtualHost>
EOF
