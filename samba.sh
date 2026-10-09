apt-get update

apt-get install -y task-samba-dc

for service in smb nmb krb5kdc slapd bind;
do
  systemctl disable $service --now;
done

rm -f /etc/samba/smb.conf

rm -f /etc/cache/smb.conf

rm -rf /var/lib/samba 
rm -rf /var/cache/samba

mkdir -p /var/lib/samba/sysvol

samba-tool domain provision \
  --realm="AU-TEAM.IRPO" \
  --domain="AU-TEAM" \
  --server-role="dc" \
  --dns-backend="SAMBA_INTERNAL" \
  --option="dns forwarder=192.168.100.2" \
  --adminpass="P@ssw0rd" 

systemctl enable --now samba

/bin/cp -f /var/lib/samba/private/krb5.conf /etc/krb5.conf

systemctl restart samba

cat > "/etc/net/ifaces/enp7s1/resolv.conf" <<EOF
search au-team.irpo
nameserver 127.0.0.1
EOF

systemctl restart network

echo "P@ssw0rd" | kinit Administrator@AU-TEAM.IRPO

samba-tool group add hq

for i in {1..5};
do
  samba-tool user add hquser$i P@ssw0rd;
  samba-tool user setexpiry hquser$i --noexpiry;
  samba-tool group addmembers "hq" hquser$i;
done

cat > /etc/chrony.conf <<EOF
server 172.16.2.1 iburst
EOF

systemctl restart chronyd
