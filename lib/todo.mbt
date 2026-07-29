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
