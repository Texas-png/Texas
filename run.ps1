# MoonTodo 启动脚本 (PowerShell)
# 使用方法: .\run.ps1

Write-Host "MoonTodo - 构建并启动服务..." -ForegroundColor Cyan

# 构建 MoonBit 后端
moon build --target native
if ($LASTEXITCODE -ne 0) {
    Write-Host "构建失败!" -ForegroundColor Red
    exit 1
}

Write-Host "服务已启动: http://localhost:8080" -ForegroundColor Green
Write-Host "按 Ctrl+C 停止服务" -ForegroundColor Yellow

# 运行后端
./target/native/main.exe
