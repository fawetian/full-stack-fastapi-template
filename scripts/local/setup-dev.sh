#!/bin/bash
# =============================================================================
# 开发环境一键配置脚本
# 用于非 Docker 本地开发环境的初始化
# =============================================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 项目根目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  FastAPI 项目 - 开发环境配置${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# -----------------------------------------------------------------------------
# 检查依赖
# -----------------------------------------------------------------------------
echo -e "${YELLOW}[1/6] 检查系统依赖...${NC}"

check_command() {
    if command -v "$1" &> /dev/null; then
        echo -e "  ${GREEN}✓${NC} $1 已安装"
        return 0
    else
        echo -e "  ${RED}✗${NC} $1 未安装"
        return 1
    fi
}

MISSING_DEPS=0

check_command "python3" || MISSING_DEPS=1
check_command "node" || MISSING_DEPS=1
check_command "npm" || MISSING_DEPS=1
check_command "psql" || MISSING_DEPS=1

# 检查 uv
if command -v uv &> /dev/null; then
    echo -e "  ${GREEN}✓${NC} uv 已安装"
else
    echo -e "  ${YELLOW}!${NC} uv 未安装，正在安装..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    source "$HOME/.cargo/env" 2>/dev/null || true
fi

if [ $MISSING_DEPS -eq 1 ]; then
    echo ""
    echo -e "${RED}请先安装缺失的依赖:${NC}"
    echo "  - Python 3.10+: https://www.python.org/"
    echo "  - Node.js 20+: https://nodejs.org/ 或使用 fnm/nvm"
    echo "  - PostgreSQL: brew install postgresql (macOS) 或 apt install postgresql (Linux)"
    exit 1
fi

echo ""

# -----------------------------------------------------------------------------
# 配置环境变量
# -----------------------------------------------------------------------------
echo -e "${YELLOW}[2/6] 配置环境变量...${NC}"

if [ -f "$PROJECT_ROOT/.env" ]; then
    echo -e "  ${GREEN}✓${NC} .env 文件已存在"
else
    if [ -f "$PROJECT_ROOT/.env.example" ]; then
        cp "$PROJECT_ROOT/.env.example" "$PROJECT_ROOT/.env"
        # 修改为本地开发配置
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' 's/POSTGRES_SERVER=db/POSTGRES_SERVER=localhost/' "$PROJECT_ROOT/.env"
        else
            sed -i 's/POSTGRES_SERVER=db/POSTGRES_SERVER=localhost/' "$PROJECT_ROOT/.env"
        fi
        echo -e "  ${GREEN}✓${NC} 已从 .env.example 创建 .env (已设置 POSTGRES_SERVER=localhost)"
    else
        echo -e "  ${RED}✗${NC} 未找到 .env.example 文件"
        exit 1
    fi
fi

echo ""

# -----------------------------------------------------------------------------
# 配置数据库
# -----------------------------------------------------------------------------
echo -e "${YELLOW}[3/6] 配置 PostgreSQL 数据库...${NC}"

# 从 .env 读取数据库配置
source "$PROJECT_ROOT/.env"

# 检查 PostgreSQL 是否运行
if pg_isready -h localhost -p ${POSTGRES_PORT:-5432} &> /dev/null; then
    echo -e "  ${GREEN}✓${NC} PostgreSQL 服务正在运行"
else
    echo -e "  ${YELLOW}!${NC} PostgreSQL 服务未运行，尝试启动..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew services start postgresql 2>/dev/null || brew services start postgresql@14 2>/dev/null || true
    else
        sudo systemctl start postgresql 2>/dev/null || sudo service postgresql start 2>/dev/null || true
    fi
    sleep 2
fi

# 尝试创建数据库和用户
echo -e "  正在配置数据库..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS - 默认使用当前用户
    createuser -s ${POSTGRES_USER:-app} 2>/dev/null || true
    createdb ${POSTGRES_DB:-app} -O ${POSTGRES_USER:-app} 2>/dev/null || true
    psql -c "ALTER USER ${POSTGRES_USER:-app} WITH PASSWORD '${POSTGRES_PASSWORD:-changethis}';" 2>/dev/null || true
else
    # Linux - 使用 postgres 用户
    sudo -u postgres createuser -s ${POSTGRES_USER:-app} 2>/dev/null || true
    sudo -u postgres createdb ${POSTGRES_DB:-app} -O ${POSTGRES_USER:-app} 2>/dev/null || true
    sudo -u postgres psql -c "ALTER USER ${POSTGRES_USER:-app} WITH PASSWORD '${POSTGRES_PASSWORD:-changethis}';" 2>/dev/null || true
fi

echo -e "  ${GREEN}✓${NC} 数据库配置完成"
echo ""

# -----------------------------------------------------------------------------
# 安装后端依赖
# -----------------------------------------------------------------------------
echo -e "${YELLOW}[4/6] 安装后端依赖...${NC}"

cd "$PROJECT_ROOT/backend"

if [ -d ".venv" ]; then
    echo -e "  ${GREEN}✓${NC} 虚拟环境已存在"
else
    echo -e "  正在创建虚拟环境..."
    uv venv
fi

echo -e "  正在安装依赖..."
uv sync

echo -e "  ${GREEN}✓${NC} 后端依赖安装完成"
echo ""

# -----------------------------------------------------------------------------
# 安装前端依赖
# -----------------------------------------------------------------------------
echo -e "${YELLOW}[5/6] 安装前端依赖...${NC}"

cd "$PROJECT_ROOT/frontend"

echo -e "  正在安装依赖..."
npm install

echo -e "  ${GREEN}✓${NC} 前端依赖安装完成"
echo ""

# -----------------------------------------------------------------------------
# 运行数据库迁移
# -----------------------------------------------------------------------------
echo -e "${YELLOW}[6/6] 运行数据库迁移...${NC}"

cd "$PROJECT_ROOT/backend"
source .venv/bin/activate

echo -e "  正在运行迁移..."
alembic upgrade head

echo -e "  正在初始化数据..."
python -m app.initial_data

echo -e "  ${GREEN}✓${NC} 数据库迁移完成"
echo ""

# -----------------------------------------------------------------------------
# 完成
# -----------------------------------------------------------------------------
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  开发环境配置完成!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "启动开发服务器:"
echo "  后端: ./scripts/local/start-backend.sh"
echo "  前端: ./scripts/local/start-frontend.sh"
echo "  全部: ./scripts/local/start-all.sh"
echo ""
echo "或手动启动:"
echo "  后端: cd backend && source .venv/bin/activate && fastapi dev app/main.py"
echo "  前端: cd frontend && npm run dev"
echo ""
echo "访问地址:"
echo "  前端: http://localhost:5173"
echo "  后端 API: http://localhost:8000"
echo "  API 文档: http://localhost:8000/docs"
