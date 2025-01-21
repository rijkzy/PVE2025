#!/bin/bash
hostnamectl set-hostname SRV2-DT

# Установка Docker
apt install -y docker.io
systemctl enable --now docker

# Создание Docker Registry
docker run -d -p 5000:5000 --restart=always --name registry registry:2

# Сборка образа web
mkdir -p /opt/web
echo "<html><body><center><h1>WEB</h1></center></body></html>" > /opt/web/index.html
echo "FROM nginx:alpine\nCOPY index.html /usr/share/nginx/html/" > /opt/web/Dockerfile
docker build -t localhost:5000/web:1.0 /opt/web
docker push localhost:5000/web:1.0

# Запуск контейнера
docker run -d --name web -p 80:80 --restart=always localhost:5000/web:1.0
