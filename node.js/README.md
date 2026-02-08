# Node.js



## 官方网站

https://nodejs.org/zh-cn



https://cloud.tencent.com/developer/article/1434735



## 安装

### 下载二进制

下载：

https://nodejs.org/dist/v24.13.0/node-v24.13.0-linux-x64.tar.xz



```bash
tar -zxvf node-v24.13.0-linux-x64.tar.xz
cp node-v24.13.0-linux-x64 /usr/local

# 添加PATH
```



### nvm安装

节点版本管理器

```bash
# 下载并安装 nvm：
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# 代替重启 shell
\. "$HOME/.nvm/nvm.sh"

# 查看是否安装成功
nvm -v	# 输出 0.40.3

# 查看可安装版本
nvm ls-remote

# 下载并安装 Node.js：
nvm install 24

# 验证 Node.js 版本：
node -v # Should print "v24.13.0".

# 验证 npm 版本：
npm -v # Should print "11.6.2".
```

