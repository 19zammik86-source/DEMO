apt-get install -y nginx apache2-htpasswd

htpasswd -bc /etc/nginx/.htpasswd WEB 'P@ssw0rd'

printf '%s\n' \
'server {' \
$'\tlisten 80;' \
$'\tserver_name web.au-team.irpo;' \
'' \
$'\tlocation / {' \
$'\t\tproxy_pass http://172.16.1.2:8080;' \
$'\t\tproxy_set_header Host $host;' \
$'\t\tproxy_set_header X-Real-IP $remote_addr;' \
$'\t\tproxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;' \
$'\t\tproxy_set_header X-Forwarded-Proto $scheme;' \
$'\t\tauth_basic "Restricted area";' \
$'\t\tauth_basic_user_file /etc/nginx/.htpasswd;' \
$'\t}' \
'}' \
'' \
'server {' \
$'\tlisten 80;' \
$'\tserver_name docker.au-team.irpo;' \
'' \
$'\tlocation / {' \
$'\t\tproxy_pass http://172.16.2.2:8080;' \
$'\t\tproxy_set_header Host $host;' \
$'\t\tproxy_set_header X-Real-IP $remote_addr;' \
$'\t\tproxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;' \
$'\t\tproxy_set_header X-Forwarded-Proto $scheme;' \
$'\t}' \
'}' \
> /etc/nginx/sites-available.d/default.conf

ln -s /etc/nginx/sites-available.d/default.conf /etc/nginx/sites-enabled.d/

nginx -t

systemctl enable --now nginx

systemctl restart nginx
