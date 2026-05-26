#!/bin/bash
apt-get update && apt-get install -y yandex-browser-stable


# Монтирование RAID 
mkdir /mnt/nfs

# Файл options
cat >> /etc/fstab <<EOF
192.168.100.2:/raid/nfs /mnt/nfs nfs rw 0 0
EOF
mount -a
ls /mnt/nfs
