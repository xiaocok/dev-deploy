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

[Releases · conda/conda](https://github.com/conda/conda/releases)

[conda | 帮助文档](https://scc.bupt.edu.cn/docs/zh/app/conda)



Windows图形界面：https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe

MacOS图形界面：https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.pkg

MacOS命令行：https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh

Linux命令行：https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh



### 超算平台专用镜像站

添加源

[scc-mirror | 帮助文档](https://scc.bupt.edu.cn/docs/zh/manual/scc-mirror)

### 安装

**通用路径**

Miniconda在路径：`/opt/app/anaconda3/Miniconda3-latest-Linux-x86_64.sh`

确定安装路径：/opt/app/anaconda3

写入环境变量

```shell
# 编辑
vim ~/.bashrc

# 添加PATH
mkdir -p /opt/app/anaconda3/
export PATH=/opt/app/anaconda3/bin:$PATH

# 生效
source ~/.bashrc

# 将安装包移动至：/opt/app/anaconda3/Miniconda3-latest-Linux-x86_64.sh
# 执行安装
cd /opt/app/anaconda3
./Miniconda3-latest-Linux-x86_64.sh
```

**默认路径**

> 默认安装路径为：~/miniconda3 

```shell
# 直接执行安装，无论安装包在哪里
./Miniconda3-latest-Linux-x86_64.sh

# 添加环境变量
vim ~/.bashrc
export PATH=~/anaconda3/bin:$PATH

# 生效
source ~/.bashrc
```

### **使用**

#### 环境管理

**创建新环境**

```shell
conda create --name <env_name> <package_names>


conda create --name py37 python=3.7 numpy pandas
```

`<env_name>`即创建的环境名。建议以英文命名，且不加空格，名称两边不加尖括号“<>”。

`<package_names>`即安装在环境中的包名。名称两边不加尖括号“<>”。如果要在新创建的环境中创建多个包，则直接在`<package_names>`后以空格隔开，添加多个包名即可。例如，创建一个名为`py37`的环境，环境中安装版本为3.7的python，同时也安装了`numpy`和`pandas`：

**切换环境**

```shell
source activate py37
conda activate py37
```

**退出环境**

```shell
conda deactivate
```

退出环境后，会切换至`base`环境

**复制环境**

```shell
conda create --name <new_env_name> --clone <old_env_name>
```

**显示环境**

```shell
conda info --envs
```

**删除环境**

```shell
conda remove --name <env_name> --all
```

#### 包管理

##### 常用操作

查看当前环境的 Python 版本

```shell
python --version
# 或
conda list python
```

创建新环境并指定 Python 版本

```shell
# 创建名为 myenv 的环境，使用 Python 3.10
conda create -n myenv python=3.10

# 激活环境
conda activate myenv

# 验证
python --version  # 输出：Python 3.10.x
```

在已有环境中升级/降级 Python

```shell
# 切换到目标环境
conda activate myenv
```

查看所有可用的 Python 版本

```shell
conda search python
```

🆚 Conda vs 系统 Python vs pyenv

| 工具                        | 能否安装 Python？ | 特点                                           |
| --------------------------- | ----------------- | ---------------------------------------------- |
| **Conda**                   | ✅ 是              | 跨平台、自带科学计算库、可管理非 Python 软件   |
| **系统包管理器**（apt/yum） | ✅ 是              | 与系统绑定，版本较旧                           |
| **pyenv**                   | ✅ 是              | 专注 Python 版本管理，轻量                     |
| **pip**                     | ❌ 否              | 只能安装 Python 包，不能安装 Python 解释器本身 |

> 💡 Conda 安装的 Python 是**独立于系统 Python 的完整副本**，不会影响系统稳定性。



##### 命令解析

**获取当前环境中已安装的包信息**

```shell
conda list
```

**在指定环境中安装包**

```shell
conda install --name <env_name> <package_name>
```

注意：

1. `<env_name>` 即将包安装的指定环境名。环境名两边不加尖括号“<>”。
2. `<package_name>` 即要安装的包名。包名两边不加尖括号“<>”。
3. 不加`-name <env_name>`，则安装到当前所在的环境。

**卸载包**

```shell
conda remove -n <env_name> <package_name>
```

#### pip

相比Anaconda，`pip`可以安装的包更多。用户可以先切换到所需环境，再在环境中执行`pip install <package_name>`。

输入`conda -v` 查看Conda版本确认已安装完成。



#### 命令参考

| 命令                                                         | 说明                   |
| ------------------------------------------------------------ | ---------------------- |
| `conda –V`                                                   | 查看conda版本          |
| `conda –h`                                                   | 查看conda帮助          |
| `conda update conda`                                         | 更新conda              |
| `conda create --name <env_name> <package_names>`             | 使用conda创建新的环境  |
| `source activate <env_name>`<br/>`conda activate <env_name>` | 激活创建的环境         |
| `conda info --envs`                                          | 显示已创建的环境       |
| `conda create --name <new_env_name> --clone <old_env_name>`  | 复制环境               |
| `deactivate <env_name>`                                      | 退出环境               |
| `conda remove --name <env_name> --all`                       | 删除环境               |
| `conda install --name <env_name> <package_name>`             | 在指定环境中安装包     |
| `conda list`                                                 | 列出已安装的包         |
| `conda update <package_name>`                                | 更新当前环境中的安装包 |
| `conda remove <package_name>`                                | 移除当前环境中的安装包 |
| `conda remove -n <env_name> <package_name>`                  | 移除指定环境中的安装包 |



## 虚拟环境venv

### 初始化虚拟环境

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



## 修改 Python 的 pip 源（镜像源）

### 找到配置文件位置

```powershell
python -m pip config debug
```

这个命令会输出 **pip 会读取的所有配置文件路径**，包括：

- 全局配置（如 `/etc/pip.conf` 或 Windows 的 `C:\ProgramData\pip\pip.ini`）
- 用户级配置（如 `%APPDATA%\pip\pip.ini`）
- 虚拟环境中的配置（如果存在 `venv/pip.conf` 或类似，虽然 Windows 下较少用）
- 环境变量（如 `PIP_CONFIG_FILE`）

输出

```powershell
env_var:
env:
global:
    C:\ProgramData\pip\pip.ini
user:
    C:\Users\<用户名>\AppData\Roaming\pip\pip.ini
site:
    D:\<porject>\.venv\pip.ini   ← 如果存在
```

> 💡 注意：`site` 行只有在虚拟环境根目录下存在 `pip.conf`（Linux/macOS）或 `pip.ini`（Windows）时才会显示。Windows 上 pip 默认**不自动创建**虚拟环境内的配置文件，但如果你手动放一个，它会被识别。



### ✅ 方法一：临时使用镜像源（单次命令）

在 `pip install` 时通过 `-i` 参数指定镜像源，例如：

```powershell
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple 包名
```

常用国内镜像源地址：

| 镜像源        | 地址                                             |
| ------------- | ------------------------------------------------ |
| 清华大学      | `https://pypi.tuna.tsinghua.edu.cn/simple`       |
| 阿里云        | `https://mirrors.aliyun.com/pypi/simple/`        |
| 豆瓣 (douban) | `https://pypi.douban.com/simple/`                |
| 中科大        | `https://pypi.mirrors.ustc.edu.cn/simple/`       |
| 腾讯云        | `https://mirrors.cloud.tencent.com/pypi/simple/` |

> ⚠️ 注意：有些镜像可能同步延迟，若安装失败可换其他源。

------

### ✅ 方法二：永久配置 pip 镜像源（推荐）

**Windows 系统（如你当前使用的 PowerShell）**

1. **创建 pip 配置目录**（如果不存在）：

   ```powershell
   mkdir %APPDATA%\pip
   ```

2. **创建或编辑配置文件**：

   ```powershell
   notepad %APPDATA%\pip\pip.ini
   ```

3. **在文件中写入以下内容**（以清华源为例）：

   ```ini
   [global]
   index-url = https://pypi.tuna.tsinghua.edu.cn/simple
   trusted-host = pypi.tuna.tsinghua.edu.cn
   ```

   > `trusted-host` 是为了跳过 SSL 证书验证（某些镜像需要）。

4. 保存并关闭。之后所有 `pip install` 都会自动使用该镜像。

------

### macOS / Linux 用户（供参考）

配置文件路径为：`~/.pip/pip.conf`
 内容同上。

------

**✅ 验证是否生效**

运行任意安装命令，观察是否从新源下载：

```powershell
pip install requests
```

输出中应包含类似：

```text
Looking in indexes: https://pypi.tuna.tsinghua.edu.cn/simple
```

------

**🔁 恢复默认源**

只需删除配置文件即可：

```powershell
del %APPDATA%\pip\pip.ini
```

或者将 `index-url` 改回官方源：

```ini
[global]
index-url = https://pypi.org/simple
```



## poetry

**Poetry 会将虚拟环境创建在：**

`~/.cache/pypoetry/virtualenvs/`（Linux/macOS）

`%LOCALAPPDATA%\pypoetry\Cache\virtualenvs\`（Windows）

目录下，这是为了统一管理所有项目的虚拟环境。



### 本地虚拟环境：

**全局**

> Poetry **优先在项目目录下使用 `.venv` 文件夹作为虚拟环境**：

```shell
# 启用本地虚拟环境
poetry config virtualenvs.in-project true

# 检查当前使用的虚拟环境路径：
poetry env info --path
# 应该输出类似：/your/project/path/.venv

# 查看当前配置
poetry config --list
# 输出内容包含：virtualenvs.in-project = true

# 删除旧的虚拟环境（如有）
poetry env remove python  # 或指定具体 Python 版本

# 重新创建虚拟环境，自动创建 .venv
poetry install
```

**临时覆盖（不推荐长期使用）**

通过环境变量临时启用本地虚拟环境（无需改全局配置）

```shell
POETRY_VIRTUALENVS_IN_PROJECT=true poetry install
```

#### ❌ 常见误区

- **不要手动创建 `venv` 或 `.venv` 并期望 Poetry 自动使用**：Poetry 只会在 `virtualenvs.in-project = true` 时**自己创建并管理 `.venv`**。
- 如果你用 `python -m venv .venv` 手动创建，Poetry **不会**自动识别（除非你后续用 `poetry env use .venv/bin/python` 显式指定）。
