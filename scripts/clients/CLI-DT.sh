#!/bin/bash
hostnamectl set-hostname CLI-DT

# Настройка сети (DHCP)
dhclient eth0

# Настройка DNS
echo "nameserver 192.168.33.10" > /etc/resolv.conf

# Настройка NTP
apt install -y chrony
echo "server 192.168.33.10 iburst" > /etc/chrony/chrony.conf
systemctl restart chrony

# Вход в домен SAMBA
apt install -y samba-client
echo "P@ssw0rd" | kinit administrator@AU.TEAM
net ads join -U administrator
