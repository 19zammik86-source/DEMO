#!/bin/bash
# Настройка hostname
hostnamectl set-hostname br-fw.au-team.irpo

apt-get update && apt-get install -y chrony tzdata


        
# Настрока часового пояса
timedatectl set-timezone Asia/Krasnoyarsk


        
# Настройка маршутизации
sed -i "s/net.ipv4.ip_forward = 0/net.ipv4.ip_forward = 1/" "/etc/net/sysctl.conf"

#Создание enp7s2
mkdir -p /etc/net/ifaces/enp7s2
cp -r /etc/net/ifaces/enp7s1/options /etc/net/ifaces/enp7s2/options
echo "192.168.0.1/28" > /etc/net/ifaces/enp7s2/ipv4address

# Настройка маршутизации
sed -i "s/net.ipv4.ip_forward = 0/net.ipv4.ip_forward = 1/" "/etc/net/sysctl.conf"

# Перезапускаем сеть
systemctl restart network

# Установка FRR (если не установлен)
apt-get install -y frr

# Включение OSPF в /etc/frr/daemons (меняем ospfd=no на ospfd=yes)
sed -i 's/ospfd=no/ospfd=yes/' /etc/frr/daemons

# Перезагрузка демона и запуск FRR
systemctl daemon-reload
systemctl enable --now frr

# Настройка OSPF через vtysh (автоматический ввод команд) МЕНЯЙТЕ НА СВОИ АДРЕСА
cat <<EOF > /etc/frr/frr.conf
router ospf

network 192.168.1.0/30 area 0
network 192.168.0.0/28 area 0
exit

do wr
exit

EOF

systemctl restart network
systemctl restart  frr 
