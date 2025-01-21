#!/bin/bash
hostnamectl set-hostname SRV1-HQ

# Настройка DNS (BIND9)
apt install -y bind9
echo "zone \"au.team\" {
  type master;
  file \"/etc/bind/db.au.team\";
  allow-transfer { 192.168.33.10; };  # SRV1-DT
};" > /etc/bind/named.conf.local

# Зона au.team
echo "\$TTL 86400
@ IN SOA srv1-hq.au.team. admin.au.team. (
  2024010101 ; Serial
  3600       ; Refresh
  1800       ; Retry
  604800     ; Expire
  86400      ; Minimum TTL
)
@ IN NS srv1-hq.au.team.
@ IN NS srv1-dt.au.team.
srv1-hq IN A 192.168.11.10
srv1-dt IN A 192.168.33.10" > /etc/bind/db.au.team
systemctl restart bind9

# Настройка NTP
apt install -y chrony
echo "server ntp2.vniiftri.ru iburst
allow 192.168.11.0/24" > /etc/chrony/chrony.conf
systemctl restart chrony

# Настройка SAMBA AD
apt install -y samba krb5-config winbind
samba-tool domain provision --realm=AU.TEAM --domain=AU --adminpass=P@ssw0rd
systemctl restart smbd nmbd winbind
