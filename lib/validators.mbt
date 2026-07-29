/// 输入校验模块

/// 校验 Todo 标题是否合法
pub fn validate_title(title : String) -> Bool {
  let trimmed = title.trim()
  !trimmed.is_empty() && trimmed.length() <= 100
}

/// 校验描述长度
pub fn validate_description(desc : String) -> Bool {
  desc.length() <= 500
}

/// 校验优先级参数
pub fn validate_priority(p : String) -> Bool {
  p == "low" || p == "medium" || p == "high"
}

/// 校验 ID 是否有效
pub fn validate_id(id : Int) -> Bool {
  id > 0
}

/// 校验并标准化请求体
pub fn validate_todo_input(title : String, description : String, priority : String) -> String? {
  if !validate_title(title) {
    return Some("标题不能为空且不超过100字符")
  }
  if !validate_description(description) {
    return Some("描述不超过500字符")
  }
  if !validate_priority(priority) {
    return Some("优先级必须为 low/medium/high")
  }
  None
}
