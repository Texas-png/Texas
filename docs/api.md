# MoonTodo API 文档

## 基础信息

- **Base URL:** `http://localhost:8080`
- **数据格式:** JSON
- **字符编码:** UTF-8

---

## 1. 获取所有待办

获取全部待办事项列表。

### 请求

```
GET /todos
```

### 响应

```json
{
  "todos": [
    {
      "id": 1,
      "title": "学习 MoonBit",
      "description": "掌握 MoonBit 基础语法",
      "priority": "high",
      "status": "pending",
      "created_at": "2026-07-29"
    }
  ]
}
```

---

## 2. 创建待办

创建一个新的待办事项。

### 请求

```
POST /todos
Content-Type: application/json

{
  "title": "新任务",
  "description": "任务描述",
  "priority": "medium"
}
```

### 字段说明

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| title | string | 是 | 任务标题 |
| description | string | 否 | 任务描述 |
| priority | string | 否 | 优先级: low / medium / high |

### 响应

```json
{
  "id": 6,
  "title": "新任务",
  "description": "任务描述",
  "priority": "medium",
  "status": "pending",
  "created_at": "2026-07-29"
}
```

---

## 3. 切换待办状态

切换指定待办事项的完成状态（pending ↔ completed）。

### 请求

```
PUT /todos/{id}
```

### 参数

| 参数 | 类型 | 说明 |
|------|------|------|
| id | int | 待办事项 ID |

### 响应

```json
{
  "id": 1,
  "title": "学习 MoonBit",
  "description": "掌握 MoonBit 基础语法",
  "priority": "high",
  "status": "completed",
  "created_at": "2026-07-29"
}
```

---

## 4. 删除待办

删除指定的待办事项。

### 请求

```
DELETE /todos/{id}
```

### 参数

| 参数 | 类型 | 说明 |
|------|------|------|
| id | int | 待办事项 ID |

### 响应

```json
{
  "ok": true
}
```

---

## 5. 错误响应

当请求出错时，返回统一格式的错误信息。

### 响应格式

```json
{
  "error": 404,
  "message": "todo not found"
}
```

### 错误码说明

| 状态码 | 说明 |
|--------|------|
| 400 | 请求参数错误 |
| 404 | 资源不存在 |
| 405 | 请求方法不允许 |
