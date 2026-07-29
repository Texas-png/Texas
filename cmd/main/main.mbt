/// MoonTodo - 待办事项管理 HTTP 服务器

fn main {
  let cfg = load_config()
  let store = Store::new()
  let csv_path = cfg.csv_path()

  // 尝试从文件加载数据
  let csv = read_file(csv_path)
  if csv.is_some() {
    store.load_from_csv(csv.unwrap())
    println("Loaded existing data from \(csv_path)")
  } else {
    println("Starting fresh database with sample data")
    store.add_todo("学习 MoonBit 基础语法", "掌握核心语言特性", High)
    store.add_todo("完善前端界面", "优化响应式布局和交互体验", Medium)
    store.add_todo("编写单元测试", "为后端逻辑添加测试覆盖", Medium)
    store.add_todo("部署上线", "将应用部署到服务器", Low)
    store.add_todo("编写使用文档", "方便其他开发者快速上手", Low)
  }

  fn handle(req : Request) -> Response {
    let path = req.path()
    let method = req.method()
    let body = req.body()
    let query = req.query()  // 查询字符串

    println("[\(now())] \(method) \(path)")

    let json = handle_request(method, path, body, store)

    // 每次请求后持久化数据
    let csv = store.save_to_csv()
    write_file(csv_path, csv)

    Response::ok(json)
      .with_header("Content-Type", "application/json")
      .with_header("Access-Control-Allow-Origin", cfg.cors_origin)
  }

  let server = HttpServer::new(cfg.port)
  server.handle("/", handle)
  server.handle("/todos", handle)
  server.handle("/todos/search", handle)
  server.handle("/stats", handle)
  println("MoonTodo v0.1 started at http://localhost:\(cfg.port)")
  println("Press Ctrl+C to stop the server")
  server.start()
}

/// 获取当前时间字符串（简化）
fn now() -> String {
  // 实际可使用 time 模块
  "timestamp"
}

// 简化的文件读写（假设 MoonBit x 库提供）
fn read_file(path : String) -> String? {
  ignore
}

fn write_file(path : String, content : String) {
  ignore
}
