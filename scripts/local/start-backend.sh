#!/bin/bash
# =============================================================================
# 启动后端开发服务器
# =============================================================================

set -e

# 项目根目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "启动后端开发服务器..."
echo ""

cd "$PROJECT_ROOT/backend"

# 激活虚拟环境
if [ -d ".venv" ]; then
    source .venv/bin/activate
else
    echo "错误: 未找到虚拟环境，请先运行 setup-dev.sh"
    exit 1
fi

# 启动开发服务器
echo "后端地址: http://localhost:8000"
echo "API 文档: http://localhost:8000/docs"
echo ""
echo "按 Ctrl+C 停止服务器"
echo ""

fastapi dev app/main.py
