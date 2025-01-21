#!/bin/bash
hostnamectl set-hostname ADMIN-HQ

# Настройка сети
ip addr add 192.168.11.100/24 dev eth0
ip link set eth0 up

# DNS и NTP
echo "nameserver 192.168.11.10" > /etc/resolv.conf
apt install -y chrony
echo "server 192.168.11.10 iburst" > /etc/chrony/chrony.conf
systemctl restart chrony

# Вход в домен SAMBA
apt install -y samba-client
echo "P@ssw0rd" | kinit administrator@AU.TEAM
net ads join -U administrator
