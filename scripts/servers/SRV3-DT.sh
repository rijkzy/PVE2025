#!/bin/bash
hostnamectl set-hostname SRV3-DT

# Установка Zabbix
apt install -y zabbix-server-pgsql zabbix-frontend-php zabbix-apache-conf zabbix-agent
sudo -u postgres createuser --pwprompt zabbix
sudo -u postgres createdb -O zabbix zabbix
zcat /usr/share/doc/zabbix-server-pgsql/create.sql.gz | sudo -u zabbix psql zabbix

# Настройка пароля БД
echo "DBPassword=zabbixpwd" >> /etc/zabbix/zabbix_server.conf
systemctl restart zabbix-server zabbix-agent apache2
systemctl enable zabbix-server zabbix-agent apache2

# Часовой пояс
timedatectl set-timezone Europe/Moscow
