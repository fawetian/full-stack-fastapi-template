#!/bin/bash
# =============================================================================
# 启动前端开发服务器
# =============================================================================

set -e

# 项目根目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "启动前端开发服务器..."
echo ""

cd "$PROJECT_ROOT/frontend"

# 检查 node_modules
if [ ! -d "node_modules" ]; then
    echo "安装前端依赖..."
    npm install
fi

# 设置 API URL (非 Docker 模式)
export VITE_API_URL=http://localhost:8000

echo "前端地址: http://localhost:5173"
echo "API 地址: $VITE_API_URL"
echo ""
echo "按 Ctrl+C 停止服务器"
echo ""

npm run dev
