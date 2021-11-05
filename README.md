# authing-code-server
通过脚本安装 code-server 以及开发依赖

## 包含
```
vim git node nvm yarn code-server zsh oh-my-zsh docker(pg redis)

并自动安装 authing 的 node 包
```


## 使用方法
准备一个纯净的 ubutnu 20.04 机器。然后跟着步骤来
```
git clone https://github.com/Mereithhh/authing-code-server

cd authing-code-server/scripts

./code-server-ubuntu-20.04-step1.sh

# 重启一下，脚本中间会提示你选一律选 Y
./code-server-ubuntu-20.04-step2.sh

# 脚本中出现描述界面按 q 推出并继续执行
./authing-init.sh

# 然后根据实际情况修改 /etc/nginx/conf.d 里面的代理配置
```
通过 http://<ip>:2333 访问你的 code-server 即可。

## 提示
此脚本包含翻墙代理，3天后自动过期。
如果脚本中出现网络断开情况，可以删除脚本里包含 `export ALL_PROXY `的那一行，并自己代理