# Developing inside a Container

https://code.visualstudio.com/docs/devcontainers/containers



## devcontainer.json文件说明

https://aka.ms/devcontainer.json

https://containers.dev/implementors/json_reference/



官方文档 **Dev Container Metadata Reference** 的 **完整中文翻译与详解**，涵盖 `devcontainer.json` 中所有字段的用途、适用场景和使用建议。

> 📌 说明：本文基于 containers.dev 官方 JSON 参考文档（截至 2025 年），结合 VS Code Dev Containers 实践经验整理，力求准确、实用。

------

### 📘 `devcontainer.json` 字段详解（中文版）

`devcontainer.json` 是 **开发容器（Dev Container）** 的核心配置文件，用于定义容器化开发环境的结构、行为和工具链。支持该规范的工具（如 VS Code、GitHub Codespaces、JetBrains Gateway 等）可据此自动创建一致的开发环境。

------

### 🔧 一、通用元数据字段（Metadata Properties）

这些字段也可通过 Docker 镜像标签 `devcontainer.metadata` 嵌入镜像中（标记为 🏷️）。

| 字段                          | 类型                    | 默认值                                                 | 说明                                                         |
| ----------------------------- | ----------------------- | ------------------------------------------------------ | ------------------------------------------------------------ |
| `name`                        | string                  | —                                                      | 在 UI 中显示的容器名称（如 VS Code 左下角状态栏）。          |
| `forwardPorts` 🏷️              | array                   | `[]`                                                   | **始终转发**的端口列表。格式： - `3000` → 转发容器 3000 到本地 - `"db:5432"` → 转发 Compose 服务 `db` 的 5432 端口 适用于无法自动探测的端口（如进程启动早于 Dev Container 连接）。 |
| `portsAttributes` 🏷️           | object                  | `{}`                                                   | 为特定端口/范围设置默认行为。例如： `json<br>"portsAttributes": {<br>  "3000": { "label": "Web App", "onAutoForward": "openBrowser" }<br>}<br>` 支持正则、范围（如 `"8000-9000"`）。 |
| `otherPortsAttributes` 🏷️      | object                  | `{}`                                                   | 为**未在 `portsAttributes` 中定义**的端口设置默认行为。 例：`"otherPortsAttributes": { "onAutoForward": "silent" }` |
| `containerEnv` 🏷️              | object                  | `{}`                                                   | 设置**整个容器**的环境变量（对所有进程生效）。 值可引用本地环境变量： `"MY_VAR": "${localEnv:MY_VAR}"` ⚠️ 修改后需**重建容器**才生效（静态）。 |
| `remoteEnv` 🏷️                 | object                  | `{}`                                                   | 仅对 **Dev Container 支持的工具/子进程**（如终端、调试器）设置环境变量。 ✅ 优点：无需重建容器即可更新（动态）。 例：`"PATH": "${containerEnv:PATH}:/custom/bin"` |
| `remoteUser` 🏷️                | string                  | 容器默认用户                                           | 指定 Dev Container 工具（如终端、任务）运行时使用的用户。 不影响容器整体运行用户（由 `containerUser` 控制）。 |
| `containerUser` 🏷️             | string                  | `root` 或 Dockerfile 中最后的 `USER`                   | 指定容器内**所有操作**的运行用户。 若同时设 `remoteUser`，则工具用 `remoteUser`，其他进程用 `containerUser`。 |
| `updateRemoteUserUID` 🏷️       | boolean                 | `true`（Linux）                                        | 在 Linux 上，若指定了用户，自动将其 UID/GID 同步为本地用户的 UID/GID，避免挂载卷权限问题。 |
| `userEnvProbe` 🏷️              | enum                    | `"loginInteractiveShell"`                              | 指定用哪种 shell 探测用户环境变量： - `none`：不探测 - `interactiveShell`：加载 `.bashrc` - `loginShell`：加载 `.profile` - `loginInteractiveShell`（默认）：加载全部 |
| `overrideCommand` 🏷️           | boolean                 | `true`（Dockerfile/image） `false`（Compose）          | 是否覆盖容器默认命令为无限休眠（`while sleep 1000; do :; done`）。 ✅ 设为 `true` 可防止容器因主进程退出而停止。 ❌ 若容器依赖默认命令（如数据库），应设为 `false`。 |
| `shutdownAction` 🏷️            | enum                    | `"stopContainer"`（单容器） `"stopCompose"`（Compose） | 关闭 VS Code 时如何处理容器： - `none`：不关闭 - `stopContainer`：停止容器 - `stopCompose`：停止整个 Compose 项目 |
| `init` 🏷️                      | boolean                 | `false`                                                | 是否启用 `tini` 初始化进程，防止僵尸进程（推荐设为 `true`）。 |
| `privileged` 🏷️                | boolean                 | `false`                                                | 是否以 `--privileged` 模式运行容器（如需 Docker-in-Docker）。⚠️ 有安全风险。 |
| `capAdd` 🏷️                    | array                   | `[]`                                                   | 添加 Linux 能力（capabilities）。 例：`["SYS_PTRACE"]`（用于 C++/Go/Rust 调试）。 |
| `securityOpt` 🏷️               | array                   | `[]`                                                   | 设置安全选项。 例：`["seccomp=unconfined"]`（禁用 seccomp，用于调试）。 |
| `mounts` 🏷️                    | string / object / array | —                                                      | 额外挂载点，语法同 `docker run --mount`。 例： `json<br>"mounts": [<br>  { "source": "dind-var-lib-docker", "target": "/var/lib/docker", "type": "volume" }<br>]<br>` |
| `features`                    | object                  | `{}`                                                   | 声明要安装的 Dev Container Features。 例： `json<br>"features": {<br>  "ghcr.io/devcontainers/features/github-cli": {}<br>}<br>` |
| `overrideFeatureInstallOrder` | array                   | —                                                      | 手动指定 Features 的安装顺序（覆盖自动依赖排序）。           |
| `customizations` 🏷️            | object                  | `{}`                                                   | 工具特定的定制配置（如 VS Code 扩展）。 例： `json<br>"customizations": {<br>  "vscode": {<br>    "extensions": ["ms-python.python"]<br>  }<br>}<br>` |

------

### 🐳 二、构建方式配置（三选一）

#### 1. 使用现成镜像（`image`）

```json
{
  "image": "python:3.12"
}
```

#### 2. 使用 Dockerfile（`build`）

```json
{
  "build": {
    "dockerfile": "Dockerfile",
    "context": "..",
    "args": { "PYTHON_VERSION": "3.12" },
    "target": "dev",
    "options": ["--add-host=host.docker.internal:host-gateway"]
  }
}
```

- `dockerfile`：相对 `devcontainer.json` 的路径
- `context`：构建上下文路径（默认 `.`）
- `args`：构建参数（可引用 `${localEnv:VAR}`）
- `target`：多阶段构建目标
- `options`：传递给 `docker build` 的额外参数

#### 3. 使用 Docker Compose（`dockerComposeFile`）

```json
{
  "dockerComposeFile": "docker-compose.yml",
  "service": "app",
  "runServices": ["app", "db"],
  "workspaceFolder": "/workspace"
}
```

- `service`：VS Code 连接的目标服务
- `runServices`：启动哪些服务（默认全部）
- `workspaceFolder`：容器内工作区路径

------

### 🛠️ 三、生命周期命令（按执行顺序）

| 命令                     | 执行位置   | 说明                                                         |
| ------------------------ | ---------- | ------------------------------------------------------------ |
| `initializeCommand`      | **宿主机** | 在容器创建前/每次启动时运行（如克隆子模块）。⚠️ 云环境中在云端执行。 |
| `onCreateCommand` 🏷️      | 容器内     | 容器首次启动后立即执行（无用户权限，适合系统级初始化）。     |
| `updateContentCommand` 🏷️ | 容器内     | 当代码内容更新时执行（如拉取新代码后）。云环境会定期运行。   |
| `postCreateCommand` 🏷️    | 容器内     | 容器分配给用户后执行（可访问用户密钥，适合 `pip install -e .`）。 |
| `postStartCommand` 🏷️     | 容器内     | **每次**容器成功启动后运行（包括重启）。                     |
| `postAttachCommand` 🏷️    | 容器内     | **每次**VS Code 连接到容器后运行（适合启动语言服务器）。     |
| `waitFor` 🏷️              | —          | 指定连接前需等待哪个命令完成（默认 `updateContentCommand`）。 |

> ✅ 所有命令支持：
>
> - 字符串：`"apt-get update && apt-get install -y curl"`
>
> - 数组：`["pip", "install", "-e", "."]`（无 shell 解析）
>
> - 对象（并行执行）：
>
>   ```json
>   "postAttachCommand": {
>     "server": "npm start",
>     "db": ["mysql", "-u", "root"]
>   }
>   ```

------

### 💻 四、主机资源要求（`hostRequirements`）

用于提示或强制满足最低硬件需求（云环境会自动选择合适实例）：

```json
{
  "hostRequirements": {
    "cpus": 2,
    "memory": "4gb",
    "storage": "32gb",
    "gpu": true  // 或 "optional"，或 { "cores": 1000, "memory": "16gb" }
  }
}
```

------

### 🌐 五、端口属性详解（`portsAttributes` 子字段）

| 属性               | 类型    | 说明                                                         |
| ------------------ | ------- | ------------------------------------------------------------ |
| `label`            | string  | 端口在 UI 中的显示名称                                       |
| `protocol`         | enum    | `"http"` / `"https"`：影响 Web 转发行为（如忽略证书）        |
| `onAutoForward`    | enum    | 自动转发时的行为： - `notify`（默认） - `openBrowser` / `openBrowserOnce` - `openPreview`（嵌入预览） - `silent`（静默） - `ignore`（不转发） |
| `requireLocalPort` | boolean | 是否强制使用相同本地端口（否则自动选可用端口）               |
| `elevateIfNeeded`  | boolean | 转发低端口（如 80）时是否自动提权                            |

------

### 📦 六、其他重要字段

| 字段              | 说明                                                         |
| ----------------- | ------------------------------------------------------------ |
| `appPort`         | **旧版端口发布方式**（推荐改用 `forwardPorts`）              |
| `workspaceMount`  | 自定义工作区挂载方式（类似 `docker run --mount`）            |
| `workspaceFolder` | 容器内工作区路径（默认 `/workspaces/${name}`）               |
| `runArgs`         | 传递给 `docker run` 的额外参数（数组格式） 例：`["--cap-add=SYS_PTRACE"]` |

------

### 🔄 七、变量替换支持

在字符串值中可使用以下变量：

| 变量                              | 说明                                                    |
| --------------------------------- | ------------------------------------------------------- |
| `${localEnv:VAR}`                 | 宿主机环境变量（可加默认值：`${localEnv:VAR:default}`） |
| `${containerEnv:VAR}`             | 容器内已有环境变量                                      |
| `${localWorkspaceFolder}`         | 本地项目路径                                            |
| `${containerWorkspaceFolder}`     | 容器内工作区路径                                        |
| `${localWorkspaceFolderBasename}` | 项目文件夹名                                            |
| `${devcontainerId}`               | 唯一容器 ID（用于 Features）                            |

------

### ✅ 最佳实践建议

1. **优先使用 `containerEnv` 而非 `remoteEnv`**（除非需要动态更新）
2. **非 root 用户运行**：设置 `containerUser` 避免权限问题
3. **启用 `init: true`** 防止僵尸进程
4. **敏感操作放 `postCreateCommand`**（可访问用户密钥）
5. **复杂依赖用 `features`** 而非写死在 Dockerfile

------

### 📚 官方参考

- 规范官网：https://containers.dev/
- JSON Schema：https://containers.dev/schema.json
- VS Code 文档：https://code.visualstudio.com/docs/devcontainers/containers

------

如果你有具体的 `devcontainer.json` 文件，我可以帮你逐行解读其作用！



## 如何主动触发启动容器 或 连接已有容器

------

### ✅ 前提条件

确保你已安装：

1. Docker

   （或 Podman）

   - 验证：终端运行 `docker --version`，应有输出

2. **VS Code**

3. VS Code 扩展：Dev Containers

   - 扩展 ID: `ms-vscode-remote.remote-containers`
   - 在扩展市场搜索 “Dev Containers” 安装即可

> 💡 如果你用的是 **Windows**，建议使用 **WSL2 + Docker Desktop** 获得最佳体验。

------

### 🚀 方法一：主动触发 —— 从本地文件夹打开并启动容器（最常用）

#### 步骤：

1. **用 VS Code 打开包含 `.devcontainer` 的项目根目录**

   ```bash
   cd /path/to/your/project  # 确保 .devcontainer/devcontainer.json 在此目录下
   code .
   ```

2. **手动触发“在容器中重新打开”**

   - 按快捷键：`Ctrl+Shift+P`（Windows/Linux）或 `Cmd+Shift+P`（macOS）

   - 输入命令：

     ```text
     Dev Containers: Reopen in Container
     ```

   - 回车执行

3. **VS Code 会自动：**

   - 构建 Docker 镜像（首次较慢）
   - 启动容器
   - 挂载项目代码
   - 安装指定的 VS Code 扩展
   - 打开终端（此时已在容器内）

✅ 成功后，VS Code 左下角状态栏会显示容器名称（如 `Dev Container: YourProject`）。

------

### 🔁 方法二：连接到一个**已经运行的 Dev Container**

如果你之前已经启动过容器，但关闭了 VS Code，现在想重新连接：

1. 打开 VS Code

2. ```
   Ctrl+Shift+P
   ```

   → 输入：

   ```text
   Dev Containers: Attach to Running Container...
   ```

3. 从列表中选择对应的容器（通常以项目名或镜像名标识）

4. VS Code 会 attach 进去，并挂载原项目目录（需路径一致）

> ⚠️ 注意：Attach 模式不会自动挂载代码，建议优先使用 “Reopen in Container”。

------

### 🧪 方法三：通过命令行启动（高级）

你也可以不依赖 VS Code UI，直接用命令构建和启动：

```bash
# 进入项目目录
cd your-project

# 使用 devcontainer CLI（需先安装）
npm install -g @devcontainers/cli

# 构建并运行
devcontainer up --workspace-folder .
```

但这通常用于 CI/自动化场景，日常开发推荐用 VS Code 图形操作。

------

### 🔍 如何确认容器是否在运行？

终端执行：

```bash
docker ps
```

你会看到类似：

```text
CONTAINER ID   IMAGE                     COMMAND                  ...
abcd1234       vsc-yourproject-xxxxxx   "/bin/sh -c 'echo Co…"   ...
```

这个就是 Dev Container 创建的容器。

------

### ❌ 常见问题排查

| 问题                              | 解决方案                                                     |
| --------------------------------- | ------------------------------------------------------------ |
| 点击 “Reopen in Container” 没反应 | 检查是否安装了 **Dev Containers 扩展**                       |
| 报错 “Docker not found”           | 确保 Docker 正在运行，且当前用户有权限（Linux 可能需 `sudo usermod -aG docker $USER`） |
| 构建卡住或失败                    | 查看构建日志，检查 `Dockerfile` 或网络（如 pip 源）          |
| 进入容器后看不到代码              | 确保 `devcontainer.json` 中 `workspaceFolder` 设置正确（默认是 `/workspaces/${localWorkspaceFolderBasename}`） |

------

### 📌 小技巧

- **重建容器**：`Ctrl+Shift+P` → `Dev Containers: Rebuild Container`（当你修改了 `Dockerfile` 或 `devcontainer.json` 后需要）
- **查看日志**：容器启动时底部会弹出 “Dev Container” 输出面板，可查看详细过程
- **退出容器**：关闭 VS Code 窗口即可，容器会自动停止（但不会删除，下次启动更快）

------

### ✅ 总结：你的操作流程

1. 安装 Docker + VS Code + Dev Containers 扩展
2. `code .` 打开项目（含 `.devcontainer/devcontainer.json`）
3. `Ctrl+Shift+P` → 输入 `Reopen in Container` → 回车
4. 等待构建完成 → 开始开发！

------

如果你愿意，可以把你的 `devcontainer.json` 内容贴出来，我可以帮你分析它具体做了什么配置！