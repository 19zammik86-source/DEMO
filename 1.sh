#!/bin/bash
apt-get update && apt-get dist-upgrade -y && update-kernel -y && apt-get clean 
apt-get install kernel-source-6.1 kernel-headers-modules-un-def gcc make kmod-sign -y
useradd irpoadmin
passwd irpoadmin
reboot
