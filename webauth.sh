apt-get install -y apache2-htpasswd
htpasswd -b -c /etc/nginx/.htpasswd WEB 'P@ssw0rd'
systemctl restart nginx
