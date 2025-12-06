## 部署

1. 执行php-fpm的docker

    nginx的docker依赖php-fpm环境

2. 执行nginx的docker


### 参考
* [使用docker搭建nginx+php环境](https://blog.csdn.net/ootiantong/article/details/109054285)





## Docker清理镜像、缓存的磁盘空间

在 Docker 中，**“未使用的 layer（层）”** 通常是指那些**不再被任何镜像、容器或缓存引用的中间层数据**。这些数据会占用磁盘空间，可以通过以下命令安全清理。

------

### ✅ 推荐方法：使用 `docker system prune`（最常用）

**1. 删除所有未使用的资源（包括 layer）**

```bash
docker system prune
```

- 删除内容：
  - 已停止的容器（stopped containers）
  - 所有未被任何容器引用的网络（dangling networks）
  - 所有 **悬空镜像（dangling images）** → 这些镜像的 layer 会被释放
  - 构建缓存（build cache）

> 💡 **悬空镜像（dangling images）**：
>  是指没有标签（`<none>:<none>`）且不被任何镜像引用的中间层，正是你所说的“未使用的 layer”的主要来源。

------

**2. 更彻底：加上 `-a` 删除所有未使用的镜像（不仅仅是悬空的）**

```bash
docker system prune -a
```

- 额外删除：
  - **所有未被任何容器使用的镜像**（即使有标签）
- ⚠️ 谨慎使用！会删掉你 pull 下来但没运行的镜像。

------

**3. 加上 `--volumes` 同时清理未使用的卷（可选）**

```bash
docker system prune -a --volumes
```

> 注意：这会删除未被容器使用的 **named volumes**，可能导致数据丢失！

------

#### 🔍 其他辅助命令

**查看当前磁盘使用情况**

```bash
docker system df
```

输出示例：

```text
TYPE            TOTAL     ACTIVE    SIZE      RECLAIMABLE
Images          10        3         5.2GB     3.8GB (73%)
Containers      3         3         120MB     0B (0%)
Local Volumes   5         2         2.1GB     1.5GB (71%)
Build Cache     20        0         800MB     800MB (100%)
```

→ 可清楚看到有多少空间可回收。

------

#### 单独清理悬空镜像（等价于 `prune` 的一部分）

```bash
docker image prune
```

或强制清理所有未用镜像：

```bash
docker image prune -a
```

------

#### 清理构建缓存（Docker BuildKit 产生的 layer）

```bash
docker builder prune
```

- 如果你经常用 `docker build`，这部分可能占很大空间。
- 加 `-a` 可清理所有构建缓存（包括正在使用的？不，只清理未引用的）。

------

#### 📌 最佳实践建议

| 场景                 | 命令                               |
| -------------------- | ---------------------------------- |
| 日常清理临时数据     | `docker system prune`              |
| 磁盘快满了，彻底清理 | `docker system prune -a --volumes` |
| 只想清理构建缓存     | `docker builder prune`             |
| 查看能清理多少空间   | `docker system df`                 |

------

#### ⚠️ 注意事项

1. **`docker system prune` 不会删除正在运行的容器或其依赖的镜像/layer**，所以是安全的。
2. **已删除镜像的 layer 会被自动回收**，无需手动操作底层文件系统。
3. 如果你使用的是 **Docker Desktop（Windows/macOS）**，清理后可能还需在 GUI 中点击 “Clean / Purge data” 释放虚拟磁盘空间。
4. 在 WSL 2 中使用 Docker Engine 时，清理后可通过 `wsl --shutdown` 重启 WSL 以释放虚拟硬盘空间（`.vhdx` 文件）。

------

#### ✅ 示例流程

```bash
# 1. 查看磁盘使用
docker system df

# 2. 安全清理（保留有标签的镜像）
docker system prune

# 3. 如果还需要更多空间，再清理未使用的镜像
docker system prune -a

# 4. 再次检查
docker system df
```

------

通过以上方法，你可以高效、安全地删除 Docker 中未使用的 layer 和其他冗余数据，释放磁盘空间。



### 如何保护重要镜像不被误删

要**避免 `docker system prune`（或 `prune -a`）误删重要镜像**，关键在于理解它的删除逻辑，并采取以下 **预防 + 保护策略**：

------

##### 🔍 首先：明确 `prune` 到底会删什么？

| 命令                     | 删除内容                                                     | 是否会删你“有用”的镜像？ |
| ------------------------ | ------------------------------------------------------------ | ------------------------ |
| `docker system prune`    | 悬空镜像（`<none>:<none>`）、停止的容器、未用网络、构建缓存  | ❌ **不会删有标签的镜像** |
| `docker system prune -a` | **所有未被容器使用的镜像**（包括 `nginx:latest` 这类有标签的！） | ✅ **会删！需特别小心**   |

> ✅ 所以：
>
> - 如果你只用 `prune`（不加 `-a`），**有标签的镜像永远安全**。
> - 如果你用了 `prune -a`，**只要镜像没被任何容器引用（即使有标签），就会被删！**

------

#### ✅ 安全策略：如何保护重要镜像不被误删？

##### ✅ 策略 1：**永远不要对生产环境盲目使用 `prune -a`**

- 只在开发机或测试环境使用 `-a`
- 生产环境建议手动清理或使用脚本精确控制

------

##### ✅ 策略 2：**给重要镜像打上“保护标签”并确保它被“引用”**

Docker 认为“正在使用”的镜像 = **被某个容器（无论运行/停止）引用**。

**方法 A：创建一个“占位容器”（推荐）**

```bash
# 为重要镜像 nginx:1.25 创建一个停止状态的容器（不运行，只占位）
docker create --name keep-nginx nginx:1.25
```

> ✅ 效果：
>  即使你不用这个容器，`nginx:1.25` 也不会被 `prune -a` 删除，因为有容器引用它。

> 🗑️ 未来想真正删除时：
>
> ```bash
> docker rm keep-nginx
> docker rmi nginx:1.25
> ```

**方法 B：保留一个运行中的容器（如监控、日志收集等）**

------

##### ✅ 策略 3：使用 `--filter` 精准排除（Docker 20.10+ 支持）

你可以通过 `label` 标记重要镜像，然后在 `prune` 时跳过它们。

**步骤：**

1. 构建或拉取镜像时加 label：

   ```bash
   docker build -t myapp:1.0 --label "keep=true" .
   # 或
   docker pull --label "keep=true" nginx:latest  # ❌ 注意：pull 不支持 --label
   ```

   > ⚠️ `docker pull` 无法直接加 label，但你可以用 `docker tag` + `docker image inspect` 后处理，或通过 Dockerfile 加 `LABEL keep=true`

2. 清理时排除带 `keep=true` 的镜像：

   ```bash
   # 目前 docker image prune 不支持 --filter by label 直接跳过
   # 但你可以用脚本实现
   ```

> 📌 实际上，**Docker 官方尚未支持 `prune --exclude-label`**，所以此方法受限。更推荐“占位容器”法。

------

##### ✅ 策略 4：使用脚本预览 + 确认（最安全）

在执行 `prune -a` 前，先列出**将被删除的镜像**：

```bash
# 查看哪些镜像会被 prune -a 删除
docker image ls --filter "dangling=false" | \
  awk 'NR>1 {print $2":"$3}' | \
  while read img; do
    if ! docker ps -a --format "{{.Image}}" | grep -q "^$img$"; then
      echo "Will be deleted: $img"
    fi
  done
```

或者更简单：

```bash
# 列出所有未被容器使用的镜像（即 prune -a 要删的）
docker image ls --format "table {{.Repository}}:{{.Tag}}\t{{.ID}}" | \
  tail -n +2 | while read line; do
    img=$(echo $line | awk '{print $1}')
    id=$(echo $line | awk '{print $2}')
    if ! docker ps -a --quiet --filter "ancestor=$id" | grep -q .; then
      echo "Not used: $img ($id)"
    fi
  done
```

✅ 确认无误后再运行 `docker system prune -a`

------

##### ✅ 策略 5：定期备份关键镜像（终极保险）

```bash
# 导出镜像为 tar 文件
docker save myapp:1.0 > myapp-1.0.tar

# 恢复时
docker load < myapp-1.0.tar
```

适合核心业务镜像做离线备份。

------

#### 🛡️ 总结：最佳实践清单

| 操作         | 建议                                             |
| ------------ | ------------------------------------------------ |
| 日常清理     | 用 `docker system prune`（不加 `-a`），绝对安全  |
| 需要深度清理 | 先用脚本预览哪些镜像会被删                       |
| 保护关键镜像 | 为其创建一个 `docker create` 的占位容器          |
| 生产环境     | 禁止直接运行 `prune -a`，改用自动化脚本 + 白名单 |
| 镜像备份     | 对核心镜像定期 `docker save`                     |

------

> 💡 **记住黄金法则**：
>  **只要有一个容器（哪怕已停止）引用了某个镜像，`docker system prune -a` 就不会删除它。**
>  利用这一点，你可以轻松“锁定”任何重要镜像。

如有具体场景（如 CI/CD 环境、多团队共享主机等），可进一步定制策略。

