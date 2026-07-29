/// 基于 CSV 的数据存储
pub struct Store {
  todos : Array[Todo]
  next_id : Int
}

pub fn Store::new() -> Store {
  Store::{todos: [], next_id: 1}
}

/// 加载所有 Todo
pub fn load_all(self : Store) -> Array[Todo] {
  self.todos
}

/// 根据 ID 查找 Todo
pub fn find_by_id(self : Store, id : Int) -> Todo? {
  self.todos.find(fn(t) { t.id == id })
}

/// 添加新 Todo
pub fn add_todo(self : Store, title : String, description : String, priority : Priority) -> Todo {
  let todo = create_todo(self.next_id, title, description, priority)
  self.todos.push(todo)
  self.next_id = self.next_id + 1
  todo
}

/// 切换 Todo 完成状态
pub fn toggle_todo(self : Store, id : Int) -> Todo? {
  let mut found : Todo? = None
  for t in self.todos {
    if t.id == id {
      t.status = match t.status {
        Pending => Completed
        Completed => Pending
      }
      found = Some(t)
      break
    }
  }
  found
}

/// 删除 Todo
pub fn remove_todo(self : Store, id : Int) -> Bool {
  let len = self.todos.length()
  self.todos = self.todos.filter(fn(t) { t.id != id })
  self.todos.length() != len
}

/// 保存到 CSV 文件
pub fn save_to_csv(self : Store) -> String {
  let mut lines : Array[String] = []
  lines.push("id,title,description,priority,status,created_at")
  for t in self.todos {
    lines.push(todo_to_csv(t))
  }
  lines.join("\n")
}

/// 从 CSV 字符串加载
pub fn load_from_csv(self : Store, csv : String) {
  let lines = csv.split("\n")
  let mut max_id = 0
  for i in 1..lines.length() {
    let line = lines[i]
    if line.trim().is_empty() { continue }
    let todo = parse_csv!(line)
    self.todos.push(todo)
    if todo.id > max_id {
      max_id = todo.id
    }
  }
  self.next_id = max_id + 1
}
