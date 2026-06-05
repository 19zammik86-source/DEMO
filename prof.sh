#===ISP===
#!/bin/bash

# Настройка hostname
hostnamectl set-hostname isp.au-team.irpo

# Настрока часового пояса
timedatectl set-timezone Asia/Krasnoyarsk

# Создаем директории для интерфейсов
mkdir -p /etc/net/ifaces/{ens19,ens20}

# Настраиваем интерфейс ens19 (статический IP)
cat <<EOF > /etc/net/ifaces/ens19/options
BOOTPROTO=static
TYPE=eth
CONFIG_WIRELESS=no
SYSTEMD_BOOTPROTO=dhcp4
CONFIG_IPV4=yes
DISABLED=no
NM_CONTROLLED=no
SYSTEMD_CONTROLLED=no
EOF

# Настраиваем интерфейс ens20 (статический IP)
cat <<EOF > /etc/net/ifaces/ens20/options
BOOTPROTO=static
TYPE=eth
CONFIG_WIRELESS=no
SYSTEMD_BOOTPROTO=dhcp4
CONFIG_IPV4=yes
DISABLED=no
NM_CONTROLLED=no
SYSTEMD_CONTROLLED=no
EOF

# Устанавливаем статические адреса для интерфейсов
echo '172.16.1.1/28' > /etc/net/ifaces/ens19/ipv4address
echo '172.16.2.1/28' > /etc/net/ifaces/ens20/ipv4address

# Настройка маршутизации
sed -i "s/net.ipv4.ip_forward = 0/net.ipv4.ip_forward = 1/" "/etc/net/sysctl.conf"

# Настройка NAT
iptables -t nat -A POSTROUTING -o ens18 -j MASQUERADE
iptables-save > /etc/sysconfig/iptables

# Добавляем IPTABLES в автозапуск
systemctl enable --now iptables

# Перезапускаем сеть
systemctl restart network

# Разрешаем root доступ по SSH
sed -i 's/#*PermitRootLogin.*/PermitRootLogin yes/' /etc/openssh/sshd_config

# Перезапускаем сервис SSHD
systemctl enable --now sshd
systemctl restart sshd.service

apt-get update

exec bash





#===HQ-RTR===
#!/bin/bash

# Настройка hostname
hostnamectl set-hostname hq-rtr.au-team.irpo

# Настрока часового пояса
timedatectl set-timezone Asia/Krasnoyarsk

# Создаем директории для интерфейсов
mkdir -p /etc/net/ifaces/ens19
mkdir -p /etc/net/ifaces/ens19.100
mkdir -p /etc/net/ifaces/ens19.200
mkdir -p /etc/net/ifaces/ens19.999
mkdir -p /etc/net/ifaces/gre1

# Настраиваем интерфейс ens18 (статический IP)
cat <<EOF > /etc/net/ifaces/ens18/options
BOOTPROTO=static
TYPE=eth
CONFIG_WIRELESS=no
SYSTEMD_BOOTPROTO=dhcp4
CONFIG_IPV4=yes
DISABLED=no
NM_CONTROLLED=no
SYSTEMD_CONTROLLED=no
EOF

cat <<EOF > /etc/net/ifaces/ens18/ipv4address
172.16.1.2/28
EOF

cat <<EOF > /etc/net/ifaces/ens18/ipv4route
default via 172.16.1.1
EOF

# Настраиваем интерфейс ens19 (статический IP)
cat <<EOF > /etc/net/ifaces/ens19/options
BOOTPROTO=static
TYPE=eth
CONFIG_WIRELESS=no
SYSTEMD_BOOTPROTO=dhcp4
CONFIG_IPV4=yes
DISABLED=no
NM_CONTROLLED=no
SYSTEMD_CONTROLLED=no
EOF

# Настраиваем VLAN ens19.100
cat <<EOF > /etc/net/ifaces/ens19.100/options
BOOTPROTO=static
TYPE=vlan
HOST=ens19
VID=100
CONFIG_WIRELESS=no
SYSTEMD_BOOTPROTO=dhcp4
CONFIG_IPV4=yes
DISABLED=no
NM_CONTROLLED=no
SYSTEMD_CONTROLLED=no
EOF

cat <<EOF > /etc/net/ifaces/ens19.100/ipv4address
192.168.1.1/27
EOF

# Настраиваем VLAN ens19.200
cat <<EOF > /etc/net/ifaces/ens19.200/options
BOOTPROTO=static
TYPE=vlan
HOST=ens19
VID=200
CONFIG_WIRELESS=no
SYSTEMD_BOOTPROTO=dhcp4
CONFIG_IPV4=yes
DISABLED=no
NM_CONTROLLED=no
SYSTEMD_CONTROLLED=no
EOF

cat <<EOF > /etc/net/ifaces/ens19.200/ipv4address
192.168.2.1/28
EOF

# Настраиваем VLAN ens19.999
cat <<EOF > /etc/net/ifaces/ens19.999/options
BOOTPROTO=static
TYPE=vlan
HOST=ens19
VID=999
CONFIG_WIRELESS=no
SYSTEMD_BOOTPROTO=dhcp4
CONFIG_IPV4=yes
DISABLED=no
NM_CONTROLLED=no
SYSTEMD_CONTROLLED=no
EOF

cat <<EOF > /etc/net/ifaces/ens19.999/ipv4address
192.168.99.1/29
EOF

# Настраиваем gre1
cat <<EOF > /etc/net/ifaces/gre1/options
TYPE=iptun
TUNTYPE=gre
TUNLOCAL=172.16.1.2
TUNREMOTE=172.16.2.2
TUNOPTIONS='ttl 64'
EOF

cat <<EOF > /etc/net/ifaces/gre1/ipv4address
10.0.0.1/30
EOF

cat <<EOF > /etc/net/ifaces/gre1/ipv4route
192.168.3.0/28 via 10.0.0.2
EOF

modprobe 8021q

# Настройка маршутизации
sed -i "s/net.ipv4.ip_forward = 0/net.ipv4.ip_forward = 1/" "/etc/net/sysctl.conf"

# Настройка iptables
iptables -t nat -A POSTROUTING -o ens18 -j MASQUERADE
iptables -t nat -A PREROUTING -i ens18 -p tcp --dport 8080 -j DNAT --to-destination 192.168.1.2:80
iptables -t nat -A PREROUTING -i ens18 -p tcp --dport 2026 -j DNAT --to-destination 192.168.1.2:2026
iptables-save > /etc/sysconfig/iptables

# Добавляем IPTABLES в автозапуск
systemctl enable --now iptables

# Добавление адреса DNS-сервера
cat <<EOF > /etc/resolv.conf
search au-team.irpo
nameserver 192.168.1.2
nameserver 77.88.8.8
EOF

# Перезапуск сетевой службы
systemctl restart network

# Создаем пользователя net_admin
useradd net_admin -m -p $(openssl passwd -1 "P@ssw0rd")
usermod -aG wheel net_admin
chage -M -1 -I -1 -E -1 net_admin

# Sudo без ввода пароля
sed -i "s/# WHEEL_USERS ALL=(ALL:ALL) NOPASSWD: ALL/WHEEL_USERS ALL=(ALL:ALL) NOPASSWD: ALL/" "/etc/sudoers"

# Изменение настроек SSH
cat <<EOF > /etc/openssh/sshd_config
Port 2026
MaxAuthTries 2
AllowUsers net_admin
PermitRootLogin no
Banner /root/banner
Subsystem sftp internal-sftp
EOF

# Создание баннера для SSH
cat <<EOF > /root/banner
Authorized access only

EOF

# Запуск и включение SSH
systemctl enable --now sshd
systemctl restart sshd

apt-get update

exec bash





#===HQ-SRV===
#!/bin/bash

# Настройка hostname
hostnamectl set-hostname hq-srv.au-team.irpo

# Настрока часового пояса
timedatectl set-timezone Asia/Krasnoyarsk

# Настраиваем интерфейс ens18 (статический IP)
cat <<EOF > /etc/net/ifaces/ens18/options
BOOTPROTO=static
TYPE=eth
CONFIG_WIRELESS=no
SYSTEMD_BOOTPROTO=dhcp4
CONFIG_IPV4=yes
DISABLED=no
NM_CONTROLLED=no
SYSTEMD_CONTROLLED=no
EOF

cat <<EOF > /etc/net/ifaces/ens18/ipv4address
192.168.1.2/27
EOF

cat <<EOF > /etc/net/ifaces/ens18/ipv4route
default via 192.168.1.1
EOF

# Добавление адреса DNS-сервера
cat <<EOF > /etc/resolv.conf
search au-team.irpo
nameserver 192.168.1.2
nameserver 77.88.8.8
EOF

# Перезапуск сетевой службы
systemctl restart network

# Создаем нового пользователя sshuser
useradd sshuser -u 2026 -p $(openssl passwd -1 "P@ssw0rd")
usermod -aG wheel sshuser
chage -M -1 -I -1 -E -1 sshuser

# Sudo без ввода пароля
sed -i "s/# WHEEL_USERS ALL=(ALL:ALL) NOPASSWD: ALL/WHEEL_USERS ALL=(ALL:ALL) NOPASSWD: ALL/" "/etc/sudoers"

# Изменение настроек SSH
cat <<EOF > /etc/openssh/sshd_config
Port 2026
MaxAuthTries 2
AllowUsers sshuser
PermitRootLogin no
Banner /root/banner
Subsystem sftp internal-sftp
EOF

# Создание баннера для SSH
cat <<EOF > /root/banner
Authorized access only

EOF


# Запуск и включение SSH
systemctl enable --now sshd
systemctl restart sshd

apt-get update

exec bash





#===HQ-CLI===
#!/bin/bash

# Настройка hostname
hostnamectl set-hostname hq-cli.au-team.irpo

# Настрока часового пояса
timedatectl set-timezone Asia/Krasnoyarsk

# Создаем директорию для сетевого интерфейса
mkdir /etc/net/ifaces/enp6s18

# Настройка ethernet-интерфейса
cat <<EOF > /etc/net/ifaces/enp6s18/options
BOOTPROTO=dhcp
TYPE=eth
CONFIG_WIRELANDS=no
SYSTEMD_BOOTPROTO=dhcp4
CONFIG_IPV4=yes
DISABLED=no
NM_CONTROLLED=no
SYSTEMD_CONTROLLED=no
EOF


# Создаем нового пользователя sshuser
useradd sshuser -u 2026 -p $(openssl passwd -1 "P@ssw0rd")
usermod -aG wheel sshuser
chage -M -1 -I -1 -E -1 sshuser

# Sudo без ввода пароля
sed -i "s/# WHEEL_USERS ALL=(ALL:ALL) NOPASSWD: ALL/WHEEL_USERS ALL=(ALL:ALL) NOPASSWD: ALL/" "/etc/sudoers"

# Изменение настроек SSH
cat <<EOF > /etc/openssh/sshd_config
Port 2026
MaxAuthTries 2
AllowUsers sshuser
PermitRootLogin no
Subsystem sftp internal-sftp
EOF

# Запуск и включение SSH
systemctl enable --now sshd
systemctl restart sshd

exec bash





#===BR-RTR===
#!/bin/bash

# Настройка hostname
hostnamectl set-hostname br-rtr.au-team.irpo

# Настрока часового пояса
timedatectl set-timezone Asia/Krasnoyarsk

# Создаем необходимые директории для сетевых интерфейсов
mkdir /etc/net/ifaces/ens19
mkdir /etc/net/ifaces/gre1

# Настройка ethernet-интерфейса ens18
cat <<EOF > /etc/net/ifaces/ens18/options
BOOTPROTO=static
TYPE=eth
CONFIG_WIRELANDS=no
SYSTEMD_BOOTPROTO=dhcp4
CONFIG_IPV4=yes
DISABLED=no
NM_CONTROLLED=no
SYSTEMD_CONTROLLED=no
EOF

cat <<EOF > /etc/net/ifaces/ens18/ipv4address
172.16.2.2/28
EOF

cat <<EOF > /etc/net/ifaces/ens18/ipv4route
default via 172.16.2.1
EOF

# Настройка ethernet-интерфейса ens19
cat <<EOF > /etc/net/ifaces/ens19/options
BOOTPROTO=static
TYPE=eth
CONFIG_WIRELANDS=no
SYSTEMD_BOOTPROTO=dhcp4
CONFIG_IPV4=yes
DISABLED=no
NM_CONTROLLED=no
SYSTEMD_CONTROLLED=no
EOF

# IP адрес ethernet-интерфейса ens19
cat <<EOF > /etc/net/ifaces/ens19/ipv4address
192.168.3.1/28
EOF

# Настройки GRE-туннеля
cat <<EOF > /etc/net/ifaces/gre1/options
TYPE=iptun
TUNTYPE=gre
TUNLOCAL=172.16.2.2
TUNREMOTE=172.16.1.2
TUNOPTIONS='ttl 64'
EOF

cat <<EOF > /etc/net/ifaces/gre1/ipv4address
10.0.0.2/30
EOF

# Маршруты через туннель
cat <<EOF > /etc/net/ifaces/gre1/ipv4route
192.168.1.0/27 via 10.0.0.1
192.168.2.0/28 via 10.0.0.1
EOF

# Настройка маршутизации
sed -i "s/net.ipv4.ip_forward = 0/net.ipv4.ip_forward = 1/" "/etc/net/sysctl.conf"

# Настройка iptables
iptables -t nat -A POSTROUTING -o ens18 -j MASQUERADE
iptables -t nat -A PREROUTING -i ens18 -p tcp --dport 8080 -j DNAT --to-destination 192.168.3.2:8080
iptables -t nat -A PREROUTING -i ens18 -p tcp --dport 2026 -j DNAT --to-destination 192.168.3.2:2026
iptables-save > /etc/sysconfig/iptables

# Добавляем IPTABLES в автозапуск
systemctl enable --now iptables

# Добавление адреса DNS-сервера
cat <<EOF > /etc/resolv.conf
search au-team.irpo
nameserver 192.168.1.2
nameserver 77.88.8.8
EOF

# Перезапуск сетевой службы
systemctl restart network

# Создаем пользователя net_admin
useradd net_admin -m -p $(openssl passwd -1 "P@ssw0rd")
usermod -aG wheel net_admin
chage -M -1 -I -1 -E -1 net_admin

# Sudo без ввода пароля
sed -i "s/# WHEEL_USERS ALL=(ALL:ALL) NOPASSWD: ALL/WHEEL_USERS ALL=(ALL:ALL) NOPASSWD: ALL/" "/etc/sudoers"

# Изменение настроек SSH
cat <<EOF > /etc/openssh/sshd_config
Port 2026
MaxAuthTries 2
AllowUsers net_admin
PermitRootLogin no
Banner /root/banner
Subsystem sftp internal-sftp
EOF

# Создание баннера для SSH
cat <<EOF > /root/banner
Authorized access only

EOF

# Запуск и включение SSH
systemctl enable --now sshd
systemctl restart sshd

apt-get update

exec bash





#===BR-SRV===
#!/bin/bash

#Настройка hostname
hostnamectl set-hostname br-srv.au-team.irpo

# Настрока часового пояса
timedatectl set-timezone Asia/Krasnoyarsk

# Настраиваем интерфейс ens18 (статический IP)
cat <<EOF > /etc/net/ifaces/ens18/options
BOOTPROTO=static
TYPE=eth
CONFIG_WIRELESS=no
SYSTEMD_BOOTPROTO=dhcp4
CONFIG_IPV4=yes
DISABLED=no
NM_CONTROLLED=no
SYSTEMD_CONTROLLED=no
EOF

cat <<EOF > /etc/net/ifaces/ens18/ipv4address
192.168.3.2/28
EOF

cat <<EOF > /etc/net/ifaces/ens18/ipv4route
default via 192.168.3.1
EOF

# Добавление адреса DNS-сервера
cat <<EOF > /etc/resolv.conf
search au-team.irpo
nameserver 192.168.1.2
nameserver 77.88.8.8
EOF

# Перезапуск сетевой службы
systemctl restart network

# Создаем нового пользователя sshuser
useradd sshuser -u 2026 -p $(openssl passwd -1 "P@ssw0rd")
usermod -aG wheel sshuser
chage -M -1 -I -1 -E -1 sshuser

# Sudo без ввода пароля
sed -i "s/# WHEEL_USERS ALL=(ALL:ALL) NOPASSWD: ALL/WHEEL_USERS ALL=(ALL:ALL) NOPASSWD: ALL/" "/etc/sudoers"

# Изменение настроек SSH
cat <<EOF > /etc/openssh/sshd_config
Port 2026
MaxAuthTries 2
AllowUsers sshuser
PermitRootLogin no
Banner /root/banner
Subsystem sftp internal-sftp
EOF

# Создание баннера для SSH
cat <<EOF > /root/banner
Authorized access only

EOF


# Запуск и включение SSH
systemctl enable --now sshd
systemctl restart sshd

apt-get update

exec bash
