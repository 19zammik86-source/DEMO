#!/bin/bash

# Установка wget
apt-get update && apt-get install wget
#Настройка ДНС
wget raw.githubusercontent.com/19zammik86-source/DEMO/refs/heads/main/dnsmasq.conf
apt-get install -y dnsmasq
systemctl enable --now dnsmasq
rm -rf /etc/dnsmasq.conf
cp -r dnsmasq.conf /etc/
systemctl restart dnsmasq
ping HQ-SRV.au-team.irpo

echo "Настройка SSH"

# Создание пользователя sshuser с UID 2027 (МЕНЯЙТЕ ИМЯ И Т.Д В ЗАВИСИМОСТИ ОТ ЗАДАНИЯ)
useradd -u 2027 -m sshuser

# Установка пароля P@ssw0rd без подтверждения
echo "sshuser:P@ssw0rd" | chpasswd

# Добавление в группу wheel
gpasswd -a sshuser wheel

# Настройка sudo без пароля
echo "sshuser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Настройка SSH
sed -i 's/#Port 22/Port 2027/' /etc/openssh/sshd_config
sed -i 's/#PermitRootLogin without-password/PermitRootLogin no/' /etc/openssh/sshd_config
echo "AllowUsers sshuser" >> /etc/openssh/sshd_config
echo "MaxAuthTries 2" >> /etc/openssh/sshd_config
echo "Banner /etc/openssh/banner" >> /etc/openssh/sshd_config

# Создание баннера
echo "Authorized access only" > /etc/openssh/banner

# Перезапуск SSH
systemctl restart sshd

echo "Настройка завершена:"
echo "- Пользователь: sshuser (пароль: P@ssw0rd)"
echo "- SSH порт: 2027"
echo "- Root-логин запрещен"
echo "- Баннер создан"


echo "Настройка RAID"
# Создание RAID 0 
mdadm --create --verbose /dev/md0 -l 0 -n 3 /dev/sd[b-d]

# Сохранение конфигурации
mdadm --detail -scan > /etc/mdadm.conf

# Работа с fdisk (автоматический ввод 'n' и 'w')
echo -e "n\n\n\n\n\nw" | fdisk /dev/md0

# Форматирование раздела
mkfs.ext4 /dev/md0p1

# Создание директории и монтирование
mkdir /raid

# Добавление в fstab
echo "/dev/md0p1 /raid ext4 defaults 0 0" >> /etc/fstab
mount -a

# Установка NFS
apt-get install -y nfs-server
systemctl enable --now nfs

# Настройка NFS
mkdir /raid/nfs
chown -R 99:99 /raid/nfs
chmod 777 /raid/nfs

# Добавление экспорта NFS МЕНЯЙТЕ НА СВОИ СЕТИ
echo "/raid/nfs 192.168.200.0/28(rw,sync,no_subtree_check)" >> /etc/exports

# Перезапуск NFS и создание тестового файла
systemctl restart nfs
touch /raid/nfs/test

echo "Готово! RAID 5 и NFS настроены."


echo "- Настройка RESOLV"
# Файл /etc/resolv.conf
cat > /etc/resolv.conf <<EOF
    nameserver 127.0.0.1
    search au-team.irpo

EOF
chattr +i /etc/resolv.conf
