#!/bin/bash


ohmyzsh() {
  echo "安装 ohmyzsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

docker() {
  echo "安装docker"
  curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
  systemctl enable docker
  systemctl start docker
}




echo "安装依赖"
# 不分开了 粗暴点
apt update
apt install git tmux wget vim -y
apt install zsh -y
chsh -s /bin/zsh
docker
export ALL_PROXY=socks5://authing:authing-code-server@home.mereith.top:19919
ohmyzsh
echo "重启后继续执行 step2"


