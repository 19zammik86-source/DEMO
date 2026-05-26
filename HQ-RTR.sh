#!/bin/bash
#Создание enp0s8
mkdir -p /etc/net/ifaces/enp0s8
cp -r /etc/net/ifaces/enp0s3/options /etc/net/ifaces/enp0s8/options

# Создание VLAN 100
mkdir -p /etc/net/ifaces/enp0s8.100/
cat > /etc/net/ifaces/enp0s8.100/options <<EOF
TYPE=vlan
HOST=enp0s8
VID=100
BOOTPROTO=static
EOF

# Создание VLAN 200
mkdir -p /etc/net/ifaces/enp0s8.200/
cat > /etc/net/ifaces/enp0s8.200/options <<EOF
TYPE=vlan
HOST=enp0s8
VID=200
BOOTPROTO=static
EOF

# Создание VLAN999
mkdir -p /etc/net/ifaces/enp0s8.999/
cat > /etc/net/ifaces/enp0s8.999/options <<EOF
TYPE=vlan
HOST=enp0s8
VID=999
BOOTPROTO=static
EOF
echo "192.168.100.1/27" > /etc/net/ifaces/enp0s8.100/ipv4address
echo "192.168.200.1/28" > /etc/net/ifaces/enp0s8.200/ipv4address
echo "192.168.99.1/29" > /etc/net/ifaces/enp0s8.999/ipv4address

# Перезапуск сети
systemctl restart network

# Установка и настройка dnsmasq
apt-get update && apt-get install -y dnsmasq
cat > /etc/dnsmasq.conf <<EOF
no-resolv
domain=au-team.irpo
dhcp-range=192.168.200.2,192.168.200.10,999h
dhcp-option=3,192.168.200.1
dhcp-option=6,192.168.100.2
dhcp-option=15,au-team.irpo
interface=enp0s8.200
EOF

# Включение и запуск dnsmasq
systemctl enable --now dnsmasq
systemctl restart dnsmasq

# Создаем директорию и файлы конфигурации
mkdir -p /etc/net/ifaces/tun0

# Файл options
cat > /etc/net/ifaces/tun0/options <<EOF
TYPE=iptun
TUNTYPE=gre
TUNLOCAL=172.16.1.2
TUNREMOTE=172.16.2.2
TUNTTL=64
TUNOPTIONS='ttl 64'
HOST=enp0s3
EOF

# Файл ipv4address
echo "10.10.10.1/30" > /etc/net/ifaces/tun0/ipv4address

# Загружаем модуль GRE и перезапускаем сеть
modprobe gre
systemctl restart network

echo "Туннель настроен"





# Установка FRR (если не установлен)
apt-get install -y frr

# Включение OSPF в /etc/frr/daemons (меняем ospfd=no на ospfd=yes)
sed -i 's/ospfd=no/ospfd=yes/' /etc/frr/daemons

# Перезагрузка демона и запуск FRR
systemctl daemon-reload
systemctl enable --now frr

# Настройка OSPF через vtysh (автоматический ввод команд) МЕНЯЙТЕ НА СВОИ АДРЕСА
vtysh << 'EOF'
conf
router ospf
network 192.168.100.0/27 area 0
network 192.168.200.0/28 area 0
network 192.168.999.0/29 area 0
network 10.10.10.0/30 area 0
exit
int tun0
ip ospf authentication message-digest
ip ospf message-digest-key 1 md5 P@ssw0rd
do wr
exit
EOF

echo "Настройка OSPF завершена!"

#ставим NAT 
iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE 
ptables -t nat -A PREROUTING -p tcp -d 192.168.100.1 --dport 2027 -j DNAT --to-destination 192.168.100.2:2027
iptables-save >> /etc/sysconfig/iptables
systemctl enable --now iptables

# 1. Создание пользователя net_admin (ЛИБО ДРУГОГО ПОЛЬЗОВАТЕЛЯ, ПРИ СМЕНЕ ПОМЕНЯТЬ В ЭТОМ ФАЙЛЕ ИМЯ И Т.Д)
useradd -m net_admin

# 2. Установка пароля P@$$word (без подтверждения)
echo "net_admin:P@ssw0rd" | chpasswd

# 3. Добавление в группу wheel
gpasswd -a net_admin wheel

# 4. Настройка sudo без пароля
echo "net_admin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# 5. Настройка SSH (порт 2026 и запрет root-логина)
sed -i 's/#Port 22/Port 2026/' /etc/openssh/sshd_config
sed -i 's/#PermitRootLogin without-password/PermitRootLogin no/' /etc/openssh/sshd_config

# 6. Перезапуск SSH
systemctl restart sshd

echo "Готово! Пользователь net_admin создан, SSH настроен на порт 2026."


