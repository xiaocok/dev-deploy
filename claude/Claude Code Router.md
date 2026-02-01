

### 参考

https://zhuanlan.zhihu.com/p/1930035012171970397

https://github.com/musistudio/claude-code-router

https://github.com/musistudio/claude-code-router/blob/main/README_zh.md

https://github.com/d-kimuson/claude-code-viewer

https://github.com/kirodotdev/Kiro

https://kiro.dev/

https://github.com/siteboon/claudecodeui

https://lazycat.cloud/playground/guideline/1416





### Claude Code

https://www.npmjs.com/package/@anthropic-ai/claude-code

https://www.npmjs.com/package/@anthropic-ai/claude-code?activeTab=versions

[2.0.74](https://www.npmjs.com/package/@anthropic-ai/claude-code/v/2.0.74)



### Claude Code Router

https://www.npmjs.com/package/@musistudio/claude-code-router



### 卸载

> 如果存在旧版本，希望卸载

```shell
# 1. 卸载现有版本
npm uninstall -g @anthropic-ai/claude-code
npm uninstall -g @musistudio/claude-code-router

# 2. 清理 npm 缓存
npm cache clean --force

# 3. 清理 ccr 本地配置缓存

rm -rf ~/.claude-code-router/cache
```



### 安装

https://github.com/musistudio/claude-code-router

```shell
# 默认安装最新版本
npm install -g @anthropic-ai/claude-code
npm install -g @musistudio/claude-code-router

# 安装制定版本、指定最后版本
npm install -g @anthropic-ai/claude-code@2.0.74
npm install -g @musistudio/claude-code-router@latest

# 安装 node-fetch 并覆盖内置 fetch
npm install -g node-fetch@3
```



### 配置

> vi ~/.claude-code-router/config.json

**deepseek示例：**

```json
{
  "APIKEY": "", // ccr的界面登录密码
  "PROXY_URL": "http://127.0.0.1:7890", // 如果有代理，配置的代理地址。注意如果是wsl，需要配置对饮的主机的代理ip，不是127.0.0.1。可以通过route -n查看。
  "LOG": true,
  "API_TIMEOUT_MS": 600000,
  "NON_INTERACTIVE_MODE": false,
  "Providers": [
    {
      "name": "deepseek",
      "api_base_url": "https://api.deepseek.com/chat/completions",
      "api_key": "", // deepseek的key
      "models": [
        "deepseek-chat"
      ],
      "transformer": {
        "use": [
          "deepseek"
        ],
        "deepseek-chat": {
          "use": [
            "tooluse"
          ]
        }
      }
    }
  ],
  "Router": {
    "default": "deepseek,deepseek-chat"
  }
}
```



**完整示例：**

```json
{
  "APIKEY": "your-secret-key",
  "PROXY_URL": "http://127.0.0.1:7890",
  "LOG": true,
  "API_TIMEOUT_MS": 600000,
  "NON_INTERACTIVE_MODE": false,
  "Providers": [
    {
      "name": "openrouter",
      "api_base_url": "https://openrouter.ai/api/v1/chat/completions",
      "api_key": "sk-xxx",
      "models": [
        "google/gemini-2.5-pro-preview",
        "anthropic/claude-sonnet-4",
        "anthropic/claude-3.5-sonnet",
        "anthropic/claude-3.7-sonnet:thinking"
      ],
      "transformer": {
        "use": ["openrouter"]
      }
    },
    {
      "name": "deepseek",
      "api_base_url": "https://api.deepseek.com/chat/completions",
      "api_key": "sk-xxx",
      "models": ["deepseek-chat", "deepseek-reasoner"],
      "transformer": {
        "use": ["deepseek"],
        "deepseek-chat": {
          "use": ["tooluse"]
        }
      }
    },
    {
      "name": "ollama",
      "api_base_url": "http://localhost:11434/v1/chat/completions",
      "api_key": "ollama",
      "models": ["qwen2.5-coder:latest"]
    },
    {
      "name": "gemini",
      "api_base_url": "https://generativelanguage.googleapis.com/v1beta/models/",
      "api_key": "sk-xxx",
      "models": ["gemini-2.5-flash", "gemini-2.5-pro"],
      "transformer": {
        "use": ["gemini"]
      }
    },
    {
      "name": "volcengine",
      "api_base_url": "https://ark.cn-beijing.volces.com/api/v3/chat/completions",
      "api_key": "sk-xxx",
      "models": ["deepseek-v3-250324", "deepseek-r1-250528"],
      "transformer": {
        "use": ["deepseek"]
      }
    },
    {
      "name": "modelscope",
      "api_base_url": "https://api-inference.modelscope.cn/v1/chat/completions",
      "api_key": "",
      "models": ["Qwen/Qwen3-Coder-480B-A35B-Instruct", "Qwen/Qwen3-235B-A22B-Thinking-2507"],
      "transformer": {
        "use": [
          [
            "maxtoken",
            {
              "max_tokens": 65536
            }
          ],
          "enhancetool"
        ],
        "Qwen/Qwen3-235B-A22B-Thinking-2507": {
          "use": ["reasoning"]
        }
      }
    },
    {
      "name": "dashscope",
      "api_base_url": "https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions",
      "api_key": "",
      "models": ["qwen3-coder-plus"],
      "transformer": {
        "use": [
          [
            "maxtoken",
            {
              "max_tokens": 65536
            }
          ],
          "enhancetool"
        ]
      }
    },
    {
      "name": "aihubmix",
      "api_base_url": "https://aihubmix.com/v1/chat/completions",
      "api_key": "sk-",
      "models": [
        "Z/glm-4.5",
        "claude-opus-4-20250514",
        "gemini-2.5-pro"
      ]
    }
  ],
  "Router": {
    "default": "deepseek,deepseek-chat",
    "background": "ollama,qwen2.5-coder:latest",
    "think": "deepseek,deepseek-reasoner",
    "longContext": "openrouter,google/gemini-2.5-pro-preview",
    "longContextThreshold": 60000,
    "webSearch": "gemini,gemini-2.5-flash"
  }
}
```



### 启动

```shell
ccr start   # 启动ccr
ccr restart # 修改配置后重启
ccr code    # 启动claude code
ccr ui      # 启动ui界面：http://127.0.0.1:3456/ui/
ccr model   # 对于偏好终端工作流的用户，可以使用交互式 CLI 模型选择器
```



### 预设管理

```shell
# 将当前配置导出为预设
ccr preset export my-preset

# 使用元数据导出
ccr preset export my-preset --description "我的 OpenAI 配置" --author "您的名字" --tags "openai,生产环境"

# 从本地目录安装预设
ccr preset install /path/to/preset

# 列出所有已安装的预设
ccr preset list

# 显示预设信息
ccr preset info my-preset

# 删除预设
ccr preset delete my-preset
```



