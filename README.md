# MoonTodo

基于 [MoonBit](https://moonbitlang.com/) 构建的轻量级待办事项管理应用。

## 架构概览

```
┌──────────────────────────────────┐
│         Frontend (HTML/CSS/JS)   │
│    响应式设计  ·  简洁 UI         │
└────────────────┬─────────────────┘
                 │ HTTP / JSON API
┌────────────────▼─────────────────┐
│      Backend (MoonBit + HTTP)     │
│  Todo 管理  │  存储引擎  │  API    │
└────────────────┬─────────────────┘
                 │
┌────────────────▼─────────────────┐
│         Data Layer (CSV)          │
│       todos.csv                   │
└──────────────────────────────────┘
```

## 项目结构

```
MoonTodo/
├── cmd/main/              # 后端入口 (MoonBit)
│   ├── main.mbt           # HTTP 服务器
│   └── moon.pkg.json
├── lib/                   # 后端核心库
│   ├── todo.mbt           # Todo 数据模型
│   ├── store.mbt          # CSV 存储引擎
│   ├── handler.mbt        # HTTP 请求处理
│   ├── validators.mbt     # 输入校验
│   └── config.mbt         # 配置管理
├── frontend/              # 前端
│   ├── index.html         # 主页面
│   ├── style.css          # 样式
│   └── app.js             # 应用逻辑
├── static/data/           # 数据目录
│   └── todos.csv          # 待办数据
├── docs/                  # 文档
│   ├── design.md          # 设计文档
│   └── api.md             # API 文档
├── .env.example           # 环境变量模板
├── .gitignore
├── LICENSE
├── moon.mod.json          # MoonBit 模块配置
├── run.ps1                # PowerShell 启动脚本
└── run.cmd                # CMD 启动脚本
```

## 快速开始

### 前置条件

- [MoonBit](https://moonbitlang.com/) (最新版本)

### 启动服务

```bash
# 构建
moon build --target native

# 启动
./run.ps1    # Windows PowerShell
# 或
./run.cmd    # Windows CMD
```

服务将在 `http://localhost:8080` 启动。

## API 端点

| 方法 | 路径 | 说明 |
|------|------|------|
| `GET` | `/todos` | 获取所有待办 |
| `POST` | `/todos` | 创建待办 |
| `PUT` | `/todos/:id` | 切换完成状态 |
| `DELETE` | `/todos/:id` | 删除待办 |
| `GET` | `/` | 前端页面 |

## 技术栈

- **后端语言:** MoonBit
- **后端运行:** MoonBit HTTP Server
- **前端:** 原生 HTML + CSS + JavaScript
- **数据存储:** CSV
