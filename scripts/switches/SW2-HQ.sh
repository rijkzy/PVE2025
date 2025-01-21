#!/bin/bash
hostnamectl set-hostname SW2-HQ

# Установка Open vSwitch
apt install -y openvswitch-switch
ovs-vsctl add-br SW2-HQ

# Привязка портов к коммутатору
for port in eth0 eth1 eth2; do
  ovs-vsctl add-port SW2-HQ $port
  ovs-vsctl set port $port up
done

# Настройка VLAN
ovs-vsctl set port eth0 tag=110  # VLAN110 (клиенты)
ovs-vsctl set port eth1 tag=220  # VLAN220 (сервера)
ovs-vsctl set port eth2 tag=330  # VLAN330 (администраторы)

# Интерфейс управления
ovs-vsctl set port SW2-HQ tag=330
ip addr add 192.168.11.3/24 dev SW2-HQ

# Настройка STP (вторичный коммутатор)
ovs-vsctl set bridge SW2-HQ stp_enable=true
ovs-vsctl set bridge SW2-HQ other_config:stp-priority=32768

# Пользователь sshuser
useradd -m -s /bin/bash sshuser
echo "sshuser:P@ssw0rd" | chpasswd
echo "sshuser ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/sshuser
