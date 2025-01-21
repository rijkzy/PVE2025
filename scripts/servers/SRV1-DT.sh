#!/bin/bash
hostnamectl set-hostname SRV1-DT

# Настройка DNS (резервный сервер)
apt update && apt install -y bind9
echo "zone \"au.team\" {
  type slave;
  file \"/var/cache/bind/db.au.team\";
  masters { 192.168.11.10; };  # Основной DNS (SRV1-HQ)
};" > /etc/bind/named.conf.local
systemctl restart bind9

# Настройка NTP
apt install -y chrony
echo "server 192.168.11.10 iburst" > /etc/chrony/chrony.conf  # Синхронизация с SRV1-HQ
systemctl restart chrony

# Настройка SAMBA AD (резервный контроллер)
apt install -y samba krb5-config winbind
samba-tool domain join au.team DC -Uadministrator --password=P@ssw0rd
systemctl restart smbd nmbd winbind

# Пользователь sshuser
useradd -m -s /bin/bash sshuser
echo "sshuser:P@ssw0rd" | chpasswd
echo "sshuser ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/sshuser
