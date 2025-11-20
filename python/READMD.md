# Python



## 二进制安装

官方文档：

https://github.com/astral-sh/python-build-standalone

https://gregoryszorc.com/docs/python-build-standalone/main/



这里下载源码，编译二进制

https://gregoryszorc.com/docs/python-build-standalone/main/building.html#linux

https://gregoryszorc.com/docs/python-build-standalone/main/building.html#macos

https://gregoryszorc.com/docs/python-build-standalone/main/building.html#windows



直接下载Release，编译好的二进制文件：

https://github.com/astral-sh/python-build-standalone/releases





用于生成 **高度可移植、独立（standalone）的 Python 二进制发行版** 的工具。它本身不是 Python 安装程序，而是构建这类二进制包的工具。

从 **Releases 页面** 下载了类似 `cpython-3.12.7+20241008-x86_64_v3-unknown-linux-gnu-install_only.tar.gz` 的文件 → ✅ 这才是真正的 **Python 二进制安装包**。



部署

```shell
sudo mkdir -p /opt/python3.12

sudo tar -xzf cpython-*.tar.gz -C /opt/python3.12 --strip-components=1
# `--strip-components=1` 是因为压缩包内通常有一个顶层目录（如 `python/`），我们希望直接把内容解压到 `/opt/python3.12` 下。


# 验证
/opt/python3.12/bin/python3 --version
# 应输出：Python 3.12.7

# 临时生效：
export PATH="/opt/python3.12/bin:$PATH"

# 永久生效（写入 shell 配置）：
echo 'export PATH="/opt/python3.12/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```



🖥️ 其他平台说明

| 平台        | 文件名特征                                       | 安装方式                                                     |
| ----------- | ------------------------------------------------ | ------------------------------------------------------------ |
| **Linux**   | `...-unknown-linux-gnu-...`                      | 解压 `.tar.gz` 即可                                          |
| **macOS**   | `...-apple-darwin-...`                           | 解压 `.tar.gz`                                               |
| **Windows** | `...-pc-windows-msvc-shared-install_only.tar.gz` | 解压到任意目录（如 `C:\Python312`），然后将 `bin`（或 `Scripts`）加入 `PATH` |

> 💡 Windows 注意：路径是 `bin\python.exe`（不是 `Scripts`），因为这是 Unix-style 布局。



📦 包含什么？

这些 standalone 包包含：

- 完整的 Python 解释器（`bin/python3`）
- 标准库
- pip、ensurepip
- 动态链接的依赖（如 OpenSSL、libffi 等）已静态链接或打包，**几乎无需系统依赖**

✅ 特别适合：

- 在老旧 Linux 系统上运行新版 Python
- 打包进 Docker 镜像
- CI/CD 环境快速部署

------

❌ 常见误区

- **不要** `git clone` 仓库后试图“安装”它——那是构建工具。
- **要**去 Releases 页面下载带 `install_only.tar.gz` 的文件。
- 不需要 `./configure`、`make`、`make install`——这是预编译好的！

------

🔗 快速获取最新版链接

官方文档推荐的下载方式（以 Linux x86_64 为例）：

```bash
# 获取最新版本信息
curl -s https://raw.githubusercontent.com/astral-sh/python-build-standalone/main/ci-targets.yaml

# 或直接访问（示例）：
https://github.com/astral-sh/python-build-standalone/releases/download/20241008/cpython-3.12.7%2B20241008-x86_64_v3-unknown-linux-gnu-install_only.tar.gz
```





## Pyenv管理

[Releases · pyenv/pyenv](https://github.com/pyenv/pyenv/releases)

✅ 推荐方式：使用 **pyenv** 安装预编译或自动编译的 Python：

```shell
# 环境支持Python3.12源码编译即可
curl https://pyenv.run | bash
pyenv install 3.12.0
pyenv global 3.12.0
```





## Conda管理工具

[Miniconda - Anaconda](https://www.anaconda.com/docs/getting-started/miniconda/main)

[Download Anaconda Distribution | Anaconda](https://www.anaconda.com/download)

[Download Success 2026 | Anaconda](https://www.anaconda.com/download/success)



Windows图形界面：https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe

MacOS图形界面：https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.pkg

MacOS命令行：https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh

Linux命令行：https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh





## 初始化虚拟环境

```shell
# 初始化环境
python -m venv .venv

✅ 正常应包含以下目录：
bin/   include/   lib/   pyvenv.cfg
或者
bin/   include/   lib/   lib64/   pyvenv.cfg

🧪 快速诊断命令
# 1. 检查 _ctypes 是否可用
python -c "import _ctypes"

# 2. 检查 venv 模块是否存在
python -m venv --help

# 3. 尝试创建测试环境
python -m venv test_venv && ls test_venv/bin
rm -rf test_venv
```

其中 `bin/` 目录包含：

- `python` → 虚拟环境解释器
- `pip`
- `activate` 脚本等



激活当前环境虚拟环境

🐧 Linux / 🍏 macOS

```shell
source .venv/bin/activate

# 退出虚拟环境：
deactivate
```

🪟 Windows

```shell
.venv\Scripts\activate.bat
# 或简写：
.venv\Scripts\activate

# 在 PowerShell 中：
.venv\Scripts\Activate.ps1

#退出虚拟环境：
deactivate
```

