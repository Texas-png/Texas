@echo off
REM MoonTodo 启动脚本 (CMD)
REM 使用方法: run.cmd

echo MoonTodo - 构建并启动服务...

REM 构建 MoonBit 后端
moon build --target native
if %ERRORLEVEL% neq 0 (
    echo 构建失败!
    exit /b 1
)

echo 服务已启动: http://localhost:8080
echo 按 Ctrl+C 停止服务

REM 运行后端
.\target\native\main.exe
