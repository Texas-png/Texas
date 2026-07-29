/// 配置管理模块

pub struct Config {
  port : Int
  data_dir : String
  cors_origin : String
}

pub fn Config::default() -> Config {
  Config::{
    port: 8080,
    data_dir: "static/data",
    cors_origin: "*",
  }
}

/// 从环境变量加载配置（简化版）
pub fn load_config() -> Config {
  let mut cfg = Config::default()
  // 注：实际项目中可从环境变量读取
  // cfg.port = env("PORT").unwrap_or("8080").parse_int().unwrap_or(8080)
  cfg
}

/// 获取 CSV 文件路径
pub fn csv_path(self : Config) -> String {
  self.data_dir + "/todos.csv"
}
