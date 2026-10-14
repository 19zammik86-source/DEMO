mkdir -p /var/www/my-domain.host/html
chown -R $root:$root /var/www/my-domain.host/html
chmod -R 755 /var/www/my-domain.host
touch /var/www/my-domain.host/html/index.html
cat > /var/www/my-domain.host/html/index.html <<EOF
<html>
   <head>
      <title>
         Domain on Nginx
      </title>
   </head>
   <body>
      <h1>
         Connection to my-domain.host is created successfully!!!
      </h1>
   </body>
</html>
EOF
touch /etc/nginx/sites-available/my-domain.host
cat > /etc/nginx/sites-available/my-domain.host <<EOF
server
   {
      listen 80;
      listen [::]:80;
      root /var/www/my-domain.host/html;
      index index.html index.htm index.nginx-debian.html;
      server_name my-domain.host www.my-domain.host;
      location /
         {
            try_files $uri $uri/ =404;
         }
   }
EOF
ln -s /etc/nginx/sites-available/my-domain.host /etc/nginx/sites-enabled/
