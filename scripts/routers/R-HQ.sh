#!/bin/bash
hostnamectl set-hostname R-HQ

# Настройка сети
ip addr add 192.168.11.1/24 dev eth0
ip link set eth0 up

# Настройка GRE-туннеля
ip tunnel add gre0 mode gre remote 192.168.33.1 local 192.168.11.1
ip addr add 10.10.10.1/30 dev gre0
ip link set gre0 up

# Настройка OSPF с аутентификацией
apt install -y quagga
echo "router ospf
 network 192.168.11.0/24 area 0
 network 10.10.10.0/24 area 0
 passive-interface eth0
 area 0 authentication message-digest
!" > /etc/quagga/ospfd.conf
systemctl restart ospfd

# Создание пользователя sshuser
useradd -m -s /bin/bash sshuser
echo "sshuser:P@ssw0rd" | chpasswd
echo "sshuser ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/sshuser
