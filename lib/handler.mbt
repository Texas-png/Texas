/// HTTP 请求处理
pub fn handle_request(method : String, path : String, body : String, store : Store) -> String {
  let parts = path.split("/")
  match method {
    "GET" => {
      match parts[1] {
        "todos" => {
          // GET /todos/search?q=keyword
          if parts.length() >= 3 && parts[2] == "search" {
            handle_search_todos(extract_query(body, "q"), store)
          } else {
            handle_list_todos(store)
          }
        }
        "stats" => store.stats()
        _ => json_error(404, "not found")
      }
    }
    "POST" => {
      match parts[1] {
        "todos" => handle_create_todo(body, store)
        _ => json_error(404, "not found")
      }
    }
    "PUT" => {
      match parts[1] {
        "todos" => {
          if parts.length() >= 3 {
            let id = parts[2].parse_int().unwrap_or(-1)
            if !validate_id(id) {
              json_error(400, "invalid id")
            } else {
              handle_toggle_todo(id, store)
            }
          } else {
            json_error(400, "missing id")
          }
        }
        _ => json_error(404, "not found")
      }
    }
    "DELETE" => {
      match parts[1] {
        "todos" => {
          if parts.length() >= 3 {
            let id = parts[2].parse_int().unwrap_or(-1)
            if !validate_id(id) {
              json_error(400, "invalid id")
            } else {
              handle_delete_todo(id, store)
            }
          } else {
            json_error(400, "missing id")
          }
        }
        _ => json_error(404, "not found")
      }
    }
    _ => json_error(405, "method not allowed")
  }
}

fn handle_list_todos(store : Store) -> String {
  let todos = sort_by_priority(store.load_all())
  let mut items : Array[String] = []
  for t in todos {
    items.push(todo_to_json(t))
  }
  "{\"todos\": [\(items.join(","))]}"
}

fn handle_search_todos(keyword : String, store : Store) -> String {
  let todos = store.search_by_keyword(keyword)
  let mut items : Array[String] = []
  for t in todos {
    items.push(todo_to_json(t))
  }
  "{\"todos\": [\(items.join(","))], \"count\": \(items.length())}"
}

fn handle_create_todo(body : String, store : Store) -> String {
  let title = extract_json_string(body, "title")
  let description = extract_json_string(body, "description")
  let priority_str = extract_json_string(body, "priority")

  // 输入校验
  match validate_todo_input(title, description, priority_str) {
    Some(err) => return json_error(400, err)
    None => {}
  }

  let priority = match priority_str {
    "high" => High
    "medium" => Medium
    _ => Low
  }
  let todo = store.add_todo(title, description, priority)
  todo_to_json(todo)
}

fn handle_toggle_todo(id : Int, store : Store) -> String {
  match store.toggle_todo(id) {
    Some(t) => todo_to_json(t)
    None => json_error(404, "todo not found")
  }
}

fn handle_delete_todo(id : Int, store : Store) -> String {
  if store.remove_todo(id) {
    "{\"ok\": true}"
  } else {
    json_error(404, "todo not found")
  }
}

fn todo_to_json(t : Todo) -> String {
  let prio = match t.priority {
    Low => "\"low\""
    Medium => "\"medium\""
    High => "\"high\""
  }
  let st = match t.status {
    Pending => "\"pending\""
    Completed => "\"completed\""
  }
  "{\"id\": \(t.id), \"title\": \"\(t.title)\", \"description\": \"\(t.description)\", \"priority\": \(prio), \"status\": \(st), \"created_at\": \"\(t.created_at)\"}"
}

fn extract_json_string(json : String, key : String) -> String {
  let search = "\"\(key)\": \""
  let start = json.find(search)
  if start.is_none() { return "" }
  let s = start.unwrap() + search.length()
  let end = json.find_from(s, "\"")
  if end.is_none() { return "" }
  json.substring(s, end.unwrap())
}

fn json_error(code : Int, msg : String) -> String {
  "{\"error\": \(code), \"message\": \"\(msg)\"}"
}

/// 从查询字符串中提取参数值
fn extract_query(query : String, key : String) -> String {
  let search = "\(key)="
  let start = query.find(search)
  if start.is_none() { return "" }
  let s = start.unwrap() + search.length()
  let end = query.find_from(s, "&")
  if end.is_none() {
    query.substring(s, query.length())
  } else {
    query.substring(s, end.unwrap())
  }
}
