#!/bin/zsh
code-server (){
  echo "安装 code server"
  curl -fsSL https://code-server.dev/install.sh | sh
  systemctl enable code-server@$USER
  mkdir -p /root/.config/code-server/ && \
  echo "bind-addr: 0.0.0.0:2333" > /root/.config/code-server/config.yaml && \
  echo "auth: password" >> /root/.config/code-server/config.yaml && \
  echo "password: $1" >> /root/.config/code-server/config.yaml && \
  echo "cert: false" >> /root/.config/code-server/config.yaml 
  systemctl start code-server@$USER
  git config --global credential.helper store
}


nvm() {
echo "安装nvm node yarn ..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install v14.18.0
nvm alias system v14.18.0
npm install --global yarn
yarn config set registry https://registry.npmmirror.com/
source ~/.zshrc
}

if [ $# -eq 1 ]; then
export ALL_PROXY=socks5://authing:authing-code-server@home.mereith.top:19919
nvm
code-server $1
else
  echo "./code-server-ubuntu-20-04-step2.sh [password]"
fi



