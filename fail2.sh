#!/bin/bash
apt-get install -y fail2ban python3-module-systemd
sed -i 's/before = paths-altlinux.conf/before = paths-altlinux-systemd.conf/' /etc/fail2ban/jail.conf
sed -i '/^\[sshd\]/a\enabled = true' /etc/fail2ban/jail.conf
sed -i '/^\[sshd\]/,/^\[/{s/^port.*/port    = 2027/}' /etc/fail2ban/jail.conf
sed -i '/^\[sshd\]/,/^\[/s/port.*2027/&\nmaxretry = 3/' /etc/fail2ban/jail.conf
sed -i '/^\[sshd\]/,/^\[/s/maxretry.*3/&\nfindtime = 10m/' /etc/fail2ban/jail.conf
sed -i '/^\[sshd\]/,/^\[/s/findtime.*10m/&\nbantime = 1m/' /etc/fail2ban/jail.conf
systemctl enable --now fail2ban
systemctl restart fail2ban
