#!/bin/bash

if [ $# -eq 2 ]; then
echo "安装编译依赖 for node-gyp"
apt install net-tools gcc python make g++ -y
echo "启动 docker"
docker run --name redis -d -p 6379:6379 --restart unless-stopped redis 
docker run --name postgres -d --restart=unless-stopped -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=authing-server -p 5432:5432 postgres
echo "克隆项目"
git clone https://$1:$2@git.authing.co/authing-next/authing-server.git
git clone https://$1:$2@git.authing.co/authing-next/authing-user-portal.git
git clone https://$1:$2@git.authing.co/authing-next/authing-fe-console.git
echo "yarn 一下"
yarn global add typescript
cd authing-fe-console && yarn && cd ..
cd authing-user-portal && yarn && cd ..
cd authing-server && yarn && cd ..
echo "安装 nginx"
apt install nginx -y
systemctl stsart nginx
systemctl enable nginx
cp ../nginx/code.conf /etc/nginx/conf.d/code.conf
cp ../nginx/authing-dev.conf /etc/nginx/conf.d/authing-dev.conf
echo "自己改去吧，/etc/nginx/conf.d 里面都是"
echo "改完 nginx -s reload 重载配置"

else
  echo "[username] [password]"
fi