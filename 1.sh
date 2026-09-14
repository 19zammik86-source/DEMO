#!/bin/bash
# Настройка hostname
hostnamectl set-hostname hq-rtr.au-team.irpo

#Создание enp7s2
mkdir -p /etc/net/ifaces/enp7s2
cp -r /etc/net/ifaces/enp7s1/options /etc/net/ifaces/enp7s2/options

# Создание VLAN 100
mkdir -p /etc/net/ifaces/enp7s2.100/
cat > /etc/net/ifaces/enp7s2.100/options <<EOF
TYPE=vlan
HOST=enp7s2
VID=100
BOOTPROTO=static
EOF

# Создание VLAN 200
mkdir -p /etc/net/ifaces/enp7s2.200/
cat > /etc/net/ifaces/enp7s2.200/options <<EOF
TYPE=vlan
HOST=enp7s2
VID=200
BOOTPROTO=static
EOF

# Создание VLAN999
mkdir -p /etc/net/ifaces/enp7s2.999/
cat > /etc/net/ifaces/enp7s2.999/options <<EOF
TYPE=vlan
HOST=enp7s2
VID=999
BOOTPROTO=static
EOF
echo "192.168.100.1/27" > /etc/net/ifaces/enp7s2.100/ipv4address
echo "192.168.200.1/28" > /etc/net/ifaces/enp7s2.200/ipv4address
echo "192.168.99.1/29" > /etc/net/ifaces/enp7s2.999/ipv4address

# Настройка маршутизации
sed -i "s/net.ipv4.ip_forward = 0/net.ipv4.ip_forward = 1/" "/etc/net/sysctl.conf"

# Перезапуск сети
systemctl restart network
