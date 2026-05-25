#!/bin/bash

# Установка wget
apt-get update && apt-get install wget

wget raw.githubusercontent.com/19zammik86-source/DEMO/refs/heads/main/dnsmasq.conf
apt-get install -y dnsmasq
systemctl enable --now dnsmasq
rm -rf /etc/dnsmasq.conf
cp -r dnsmasq.conf /etc/
systemctl restart dnsmasq

