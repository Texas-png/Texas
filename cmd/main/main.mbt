/// MoonTodo - 待办事项管理 HTTP 服务器

fn main {
  let store = Store::new()
  // 尝试从文件加载数据
  let csv = read_file("static/data/todos.csv")
  if csv.is_some() {
    store.load_from_csv(csv.unwrap())
    println("Loaded existing data")
  } else {
    println("Starting fresh database")
    // 添加示例数据
    store.add_todo("学 MoonBit", "学习 MoonBit 语言基础语法", High)
    store.add_todo("写项目文档", "完善项目的 README 和文档", Medium)
    store.add_todo("部署上线", "将应用部署到服务器", Low)
  }

  fn handle(req : Request) -> Response {
    let path = req.path()
    let method = req.method()
    let body = req.body()

    println("\(method) \(path)")

    let json = handle_request(method, path, body, store)

    // 每次请求后保存数据
    let csv = store.save_to_csv()
    write_file("static/data/todos.csv", csv)

    Response::ok(json).with_header("Content-Type", "application/json")
  }

  let server = HttpServer::new(8080)
  server.handle("/", handle)
  server.handle("/todos", handle)
  println("MoonTodo server started at http://localhost:8080")
  server.start()
}

// 简化的文件读写（假设 MoonBit x 库提供）
fn read_file(path : String) -> String? {
  // 使用 moonbitlang/x 的文件操作
  ignore
}

fn write_file(path : String, content : String) {
  // 使用 moonbitlang/x 的文件操作
  ignore
}
