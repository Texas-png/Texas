# MoonTodo 设计文档

## 架构设计

MoonTodo 采用前后端分离的架构设计：

- **后端**：MoonBit 语言编写，负责业务逻辑处理和 API 服务
- **前端**：原生 HTML/CSS/JavaScript，负责界面展示和用户交互
- **数据层**：CSV 文件存储，保证数据的持久化

## 数据流

```
用户操作 → 前端页面 → HTTP 请求 → MoonBit 后端 → CSV 文件
用户界面 ← 响应渲染 ← JSON 响应 ← 业务处理 ←    ↑
```

## 模块设计

### lib/todo.mbt — 数据模型

定义 Todo 的核心数据结构，包括：
- `Priority` 枚举：Low / Medium / High
- `Status` 枚举：Pending / Completed
- `Todo` 结构体：id, title, description, priority, status, created_at
- CSV 序列化/反序列化方法

### lib/store.mbt — 存储引擎

管理 Todo 数据的增删改查操作：
- 基于数组的内存存储
- 自动递增 ID 生成
- CSV 导入导出

### lib/handler.mbt — 请求处理

处理 HTTP 请求并返回 JSON 响应：
- 路由分发：根据 method + path 匹配到对应处理函数
- JSON 序列化：将 Todo 对象转为 JSON 字符串
- 错误处理：返回标准化的错误 JSON

### cmd/main/main.mbt — 入口

HTTP 服务器启动和全局配置：
- 初始化存储引擎
- 从 CSV 加载已有数据
- 注册路由处理函数
- 启动 HTTP 服务

## API 设计原则

- 使用 RESTful 风格
- 请求/响应均使用 JSON 格式
- 统一的错误响应格式

## 技术选型理由

| 技术 | 选择理由 |
|------|---------|
| MoonBit | 高性能、强类型、Web 应用开发支持 |
| CSV | 轻量级、人类可读、无需数据库依赖 |
| 原生前端 | 零依赖、快速加载、易于维护 |
