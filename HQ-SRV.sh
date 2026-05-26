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

# Файл /etc/resolv.conf
cat > /etc/resolv.conf <<EOF
    nameserver 127.0.0.1
    search au-team.irpo

EOF
chattr +i /etc/resolv.conf
