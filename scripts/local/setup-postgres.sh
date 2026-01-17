#!/bin/bash
# =============================================================================
# PostgreSQL 数据库初始化脚本
# 用于创建数据库用户和数据库
# =============================================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 项目根目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo -e "${YELLOW}PostgreSQL 数据库初始化${NC}"
echo ""

# 加载环境变量
if [ -f "$PROJECT_ROOT/.env" ]; then
    source "$PROJECT_ROOT/.env"
else
    echo -e "${RED}错误: 未找到 .env 文件${NC}"
    echo "请先复制 .env.example 为 .env 并配置数据库信息"
    exit 1
fi

# 默认值
DB_USER=${POSTGRES_USER:-app}
DB_PASSWORD=${POSTGRES_PASSWORD:-changethis}
DB_NAME=${POSTGRES_DB:-app}
DB_PORT=${POSTGRES_PORT:-5432}

echo "数据库配置:"
echo "  用户名: $DB_USER"
echo "  数据库: $DB_NAME"
echo "  端口: $DB_PORT"
echo ""

# 检测操作系统
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "${YELLOW}检测到 macOS 系统${NC}"
    
    # 检查 PostgreSQL 是否通过 brew 安装
    if ! command -v psql &> /dev/null; then
        echo -e "${YELLOW}正在通过 Homebrew 安装 PostgreSQL...${NC}"
        brew install postgresql@14
        brew services start postgresql@14
        sleep 3
    fi
    
    # 启动服务
    brew services start postgresql 2>/dev/null || brew services start postgresql@14 2>/dev/null || true
    sleep 2
    
    # 创建用户和数据库 (macOS 默认使用当前用户)
    echo "创建数据库用户..."
    createuser -s "$DB_USER" 2>/dev/null || echo "  用户可能已存在"
    
    echo "设置用户密码..."
    psql postgres -c "ALTER USER $DB_USER WITH PASSWORD '$DB_PASSWORD';" 2>/dev/null || true
    
    echo "创建数据库..."
    createdb "$DB_NAME" -O "$DB_USER" 2>/dev/null || echo "  数据库可能已存在"
    
else
    echo -e "${YELLOW}检测到 Linux 系统${NC}"
    
    # 检查 PostgreSQL 是否安装
    if ! command -v psql &> /dev/null; then
        echo -e "${YELLOW}正在安装 PostgreSQL...${NC}"
        if command -v apt &> /dev/null; then
            sudo apt update
            sudo apt install -y postgresql postgresql-contrib
        elif command -v yum &> /dev/null; then
            sudo yum install -y postgresql-server postgresql-contrib
            sudo postgresql-setup --initdb
        fi
    fi
    
    # 启动服务
    sudo systemctl start postgresql 2>/dev/null || sudo service postgresql start 2>/dev/null || true
    sudo systemctl enable postgresql 2>/dev/null || true
    sleep 2
    
    # 创建用户和数据库 (Linux 使用 postgres 用户)
    echo "创建数据库用户..."
    sudo -u postgres createuser -s "$DB_USER" 2>/dev/null || echo "  用户可能已存在"
    
    echo "设置用户密码..."
    sudo -u postgres psql -c "ALTER USER $DB_USER WITH PASSWORD '$DB_PASSWORD';" 2>/dev/null || true
    
    echo "创建数据库..."
    sudo -u postgres createdb "$DB_NAME" -O "$DB_USER" 2>/dev/null || echo "  数据库可能已存在"
fi

# 验证连接
echo ""
echo "验证数据库连接..."
if PGPASSWORD="$DB_PASSWORD" psql -h localhost -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -c "SELECT 1;" &> /dev/null; then
    echo -e "${GREEN}✓ 数据库连接成功!${NC}"
else
    echo -e "${RED}✗ 数据库连接失败${NC}"
    echo ""
    echo "可能的原因:"
    echo "  1. PostgreSQL 服务未启动"
    echo "  2. 密码不正确"
    echo "  3. pg_hba.conf 配置问题"
    echo ""
    echo "请检查 PostgreSQL 配置并重试"
    exit 1
fi

echo ""
echo -e "${GREEN}数据库初始化完成!${NC}"
