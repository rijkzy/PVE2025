#!/bin/bash
hostnamectl set-hostname FW-DT

# Настройка сети
ip addr add 192.168.33.254/24 dev eth0
ip link set eth0 up

# Правила iptables
iptables -A FORWARD -s 192.168.33.0/24 -d 192.168.11.0/24 -j ACCEPT
iptables -A FORWARD -s 192.168.11.0/24 -d 192.168.33.0/24 -j ACCEPT
iptables -A INPUT -p icmp -s 192.168.33.0/24 -j ACCEPT

# Настройка OSPF (только для маршрутизации)
apt install -y quagga
echo "router ospf
 network 192.168.33.0/24 area 0
!" > /etc/quagga/ospfd.conf
systemctl restart ospfd
