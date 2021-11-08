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
cat > /etc/nginx/conf.d/code.conf << EOF
  server {
    listen 443   ssl http2;
    server_name code.h.mereith.com;
    proxy_buffers 8 32k;
    proxy_buffer_size 64k;
    client_max_body_size 750M;
    ssl_certificate /var/cert/h.mereith.com.crt;
    ssl_certificate_key /var/cert/h.mereith.com.key;
    ssl_verify_client off;
    proxy_ssl_verify off;
    location / {
        proxy_pass  http://127.0.0.1:2333;
        proxy_set_header Host \$http_host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_read_timeout 999999999;
    }
  }
EOF
cat > /etc/nginx/conf.d/authing.conf << EOF
  server {
    listen 80;
    server_name *.cj.mereith.com;
    proxy_buffering on;


    location  / {
        proxy_pass  http://127.0.0.1:3000;
        proxy_set_header Host \$http_host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_read_timeout 999999999;
    }
    location ^~ /authing-fe-user-portal-dev/ {
        rewrite ^/authing-fe-user-portal-dev/(.*) http://cj-authing-dev-user-portal.mereith.com/$1 last;
    }
    location ^~ /authing-fe-console-dev/ {
        rewrite ^/authing-fe-console-dev/(.*) http://cj-authing-dev-console.mereith.com/$1 last;
    }
}
server {
        listen 80;
        server_name cj-authing-dev-user-portal.mereith.com;
        location / {
                proxy_pass http://127.0.0.1:3002;
        }
}
server {
        listen 80;
        server_name cj-authing-dev-console.mereith.com;
        location / {
                proxy_pass http://127.0.0.1:3001;
        }
}
server {
    listen 443 ssl;
    server_name es.cj.mereith.com;
    proxy_buffers 8 32k;
    proxy_buffer_size 64k;

    client_max_body_size 750M;
    ssl_certificate /var/cert/cj.mereith.com.crt;
    ssl_certificate_key /var/cert/cj.mereith.com.key;
    ssl_verify_client off;
    proxy_ssl_verify off;
    location / {
        proxy_pass  http://127.0.0.1:9200;
        proxy_set_header Host \$http_host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_read_timeout 999999999;
    }
}


server {
    listen 80;
    server_name es.cj.mereith.com;
    return  301 https://es.cj.mereith.com:8443;
}
EOF
echo "自己改去吧，/etc/nginx/conf.d 里面都是"
echo "改完 nginx -s reload 重载配置"

else
  echo "[username] [password]"
fi