#!/bin/bash
# =============================================================================
# 同时启动后端和前端开发服务器
# =============================================================================

set -e

# 项目根目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  启动所有开发服务器${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 清理函数
cleanup() {
    echo ""
    echo -e "${YELLOW}正在停止所有服务...${NC}"
    kill $BACKEND_PID 2>/dev/null || true
    kill $FRONTEND_PID 2>/dev/null || true
    echo -e "${GREEN}服务已停止${NC}"
    exit 0
}

trap cleanup SIGINT SIGTERM

# 启动后端
echo -e "${YELLOW}启动后端服务器...${NC}"
cd "$PROJECT_ROOT/backend"
source .venv/bin/activate
fastapi dev app/main.py &
BACKEND_PID=$!
echo -e "${GREEN}✓${NC} 后端已启动 (PID: $BACKEND_PID)"

# 等待后端启动
sleep 3

# 启动前端
echo -e "${YELLOW}启动前端服务器...${NC}"
cd "$PROJECT_ROOT/frontend"
export VITE_API_URL=http://localhost:8000
npm run dev &
FRONTEND_PID=$!
echo -e "${GREEN}✓${NC} 前端已启动 (PID: $FRONTEND_PID)"

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  所有服务已启动${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "访问地址:"
echo "  前端: http://localhost:5173"
echo "  后端 API: http://localhost:8000"
echo "  API 文档: http://localhost:8000/docs"
echo ""
echo "按 Ctrl+C 停止所有服务"
echo ""

# 等待子进程
wait
