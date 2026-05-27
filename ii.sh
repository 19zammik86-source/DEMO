# Файл /etc/strongswan/ipsec.conf
cat > /etc/strongswan/ipsec.conf <<EOF
config setup
    uniqueids = yes
    charondebug="ike 2, knl 2, cfg 2, mgr 2, chd 2"
conn hq-rtr.au-team.irpo
    type=transport
    left=172.16.2.2
    leftid=172.16.2.2
    right=172.16.1.2
    rightid=172.16.1.2
    authby=secret
    ike=aes256-sha256-modp2048!
    esp=aes256-sha256!
    keyexchange=ikev2
    ikelifetime=24h
    lifetime=8h
    dpddelay=30
    dpdtimeout=120
    dpdaction=restart
    auto=start
EOF

# Файл /etc/strongswan/ipsec.secrets
cat > /etc/strongswan/ipsec.secrets <<EOF
172.16.2.2 172.16.1.2 : PSK "P@ssw0rd"
EOF
