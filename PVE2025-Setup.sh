#!/bin/bash

# Конфигурация
REPO="rijkzy/PVE2025"
BRANCH="main"
SCRIPTS_DIR="scripts"

# Функция для скачивания и запуска скрипта
run_script() {
    local device_type=$1
    local script_name=$2
    local device_ip=$3

    echo "🔧 Настройка устройства: $device_type ($device_ip)"
    curl -sfOL "https://raw.githubusercontent.com/$REPO/$BRANCH/$SCRIPTS_DIR/$device_type/$script_name" && {
        chmod +x "$script_name"
        ./"$script_name"
        rm -f "$script_name"
    } || echo -e "\e[1;33m\nОшибка скачивания: проверьте подключение к Интернету, настройки DNS, прокси и URL адрес\ncurl exit code: $?\n\e[m" >&2
}

# Основной блок
echo "### Настройка устройств ###"

# Маршрутизаторы
run_script "routers" "R-HQ.sh" "192.168.11.1"
run_script "routers" "R-DT.sh" "192.168.33.1"

# Коммутаторы
run_script "switches" "SW1-HQ.sh" "192.168.11.2"
run_script "switches" "SW2-HQ.sh" "192.168.11.3"
run_script "switches" "SW3-HQ.sh" "192.168.11.4"
run_script "switches" "SW-DT.sh" "192.168.33.2"

# Серверы
run_script "servers" "SRV1-HQ.sh" "192.168.11.10"
run_script "servers" "SRV1-DT.sh" "192.168.33.10"
run_script "servers" "SRV2-DT.sh" "192.168.33.20"
run_script "servers" "SRV3-DT.sh" "192.168.33.30"

# Межсетевые экраны
run_script "firewalls" "FW-DT.sh" "192.168.33.254"

# Клиенты
run_script "clients" "ADMIN-HQ.sh" "192.168.11.100"
run_script "clients" "CLI-HQ.sh" "192.168.11.101"
run_script "clients" "ADMIN-DT.sh" "192.168.33.100"
run_script "clients" "CLI-DT.sh" "192.168.33.101"

echo "### Настройка завершена ###"
