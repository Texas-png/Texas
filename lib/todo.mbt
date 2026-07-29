/// Todo 优先级枚举
enum Priority {
  Low
  Medium
  High
}

/// Todo 状态枚举
enum Status {
  Pending
  Completed
}

/// Todo 数据模型
struct Todo {
  id : Int
  title : String
  description : String
  priority : Priority
  status : Status
  created_at : String
}

/// 创建一个新的 Todo
pub fn create_todo(id : Int, title : String, description : String, priority : Priority) -> Todo {
  Todo::{
    id,
    title,
    description,
    priority,
    status: Pending,
    created_at: "now",
  }
}

/// 将 Todo 转换为 CSV 行
pub fn todo_to_csv(t : Todo) -> String {
  let prio = match t.priority {
    Low => "low"
    Medium => "medium"
    High => "high"
  }
  let st = match t.status {
    Pending => "pending"
    Completed => "completed"
  }
  "\(t.id),\(t.title),\(t.description),\(prio),\(st),\(t.created_at)"
}

/// 按优先级排序（高 → 低）
pub fn sort_by_priority(todos : Array[Todo]) -> Array[Todo] {
  let mut sorted = todos.clone()
  sorted.sort(fn(a, b) {
    let pa = match a.priority { High => 3; Medium => 2; Low => 1 }
    let pb = match b.priority { High => 3; Medium => 2; Low => 1 }
    pb - pa
  })
  sorted
}

/// 获取待办总数
pub fn count_todos(todos : Array[Todo]) -> (Int, Int) {
  let total = todos.length()
  let done = todos.count(fn(t) { match t.status { Completed => true; _ => false } })
  (total, done)
}

/// 格式化创建时间为可读字符串
pub fn format_date(t : Todo) -> String {
  t.created_at
}

/// 从 CSV 行解析 Todo
pub fn parse_csv(line : String) -> Todo!String {
  let parts : Array[String] = line.split(",")
  if parts.length() < 6 {
    abort("invalid csv line")
  }
  let id = parts[0].parse_int().unwrap()
  let priority = match parts[3] {
    "low" => Low
    "medium" => Medium
    "high" => High
    _ => Medium
  }
  let status = match parts[4] {
    "pending" => Pending
    "completed" => Completed
    _ => Pending
  }
  Todo::{
    id,
    title: parts[1],
    description: parts[2],
    priority,
    status,
    created_at: parts[5],
  }
}
