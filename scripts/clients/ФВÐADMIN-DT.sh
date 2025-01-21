#!/bin/bash
hostnamectl set-hostname ADMIN-DT

# Настройка сети
ip addr add 192.168.33.100/24 dev eth0
ip link set eth0 up

# Настройка DNS
echo "nameserver 192.168.33.10" > /etc/resolv.conf  # Резервный DNS (SRV1-DT)

# Настройка NTP
apt install -y chrony
echo "server 192.168.33.10 iburst" > /etc/chrony/chrony.conf  # Синхронизация с SRV1-DT
systemctl restart chrony

# Вход в домен SAMBA
apt install -y samba-client
echo "P@ssw0rd" | kinit administrator@AU.TEAM
net ads join -U administrator

# Настройка политик ADMC (пример)
echo "Запрет изменения сетевых настроек для CLI..."
# Дополнительные команды для ADMC
