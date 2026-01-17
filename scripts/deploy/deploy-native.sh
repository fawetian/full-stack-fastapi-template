#!/bin/bash
# =============================================================================
# 非 Docker 首次部署脚本
# 用于 Linux 服务器 (Ubuntu/Debian) 的完整部署流程
# =============================================================================
# 使用方法:
#   1. 将项目代码上传到服务器
#   2. 修改脚本中的配置变量
#   3. 运行: sudo bash scripts/deploy/deploy-native.sh
# =============================================================================

set -e

# =============================================================================
# 配置区域 - 请根据实际情况修改
# =============================================================================

# 应用部署路径
APP_DIR="/var/www/fastapi-app"

# 域名配置
API_DOMAIN="api.your-domain.com"
DASHBOARD_DOMAIN="dashboard.your-domain.com"

# 运行用户
APP_USER="www-data"

# Let's Encrypt 邮箱
CERTBOT_EMAIL="admin@your-domain.com"

# =============================================================================
# 脚本开始
# =============================================================================

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  FastAPI 应用部署脚本${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 检查 root 权限
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}请使用 sudo 运行此脚本${NC}"
    exit 1
fi

# -----------------------------------------------------------------------------
# 1. 安装系统依赖
# -----------------------------------------------------------------------------
echo -e "${YELLOW}[1/8] 安装系统依赖...${NC}"

apt update
apt install -y \
    python3 python3-pip python3-venv \
    postgresql postgresql-contrib \
    nginx \
    certbot python3-certbot-nginx \
    curl git build-essential

# 安装 Node.js (使用 NodeSource)
if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt install -y nodejs
fi

# 安装 uv
if ! command -v uv &> /dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

echo -e "${GREEN}✓${NC} 系统依赖安装完成"
echo ""

# -----------------------------------------------------------------------------
# 2. 配置 PostgreSQL
# -----------------------------------------------------------------------------
echo -e "${YELLOW}[2/8] 配置 PostgreSQL...${NC}"

# 启动 PostgreSQL
systemctl start postgresql
systemctl enable postgresql

# 从 .env 读取数据库配置
if [ -f "$APP_DIR/.env" ]; then
    source "$APP_DIR/.env"
fi

DB_USER=${POSTGRES_USER:-app}
DB_PASSWORD=${POSTGRES_PASSWORD:-changethis}
DB_NAME=${POSTGRES_DB:-app}

# 创建数据库用户和数据库
sudo -u postgres psql -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';" 2>/dev/null || true
sudo -u postgres psql -c "CREATE DATABASE $DB_NAME OWNER $DB_USER;" 2>/dev/null || true
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;" 2>/dev/null || true

echo -e "${GREEN}✓${NC} PostgreSQL 配置完成"
echo ""

# -----------------------------------------------------------------------------
# 3. 创建应用目录
# -----------------------------------------------------------------------------
echo -e "${YELLOW}[3/8] 配置应用目录...${NC}"

# 创建目录
mkdir -p "$APP_DIR"

# 如果当前目录不是 APP_DIR，复制文件
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

if [ "$PROJECT_ROOT" != "$APP_DIR" ]; then
    echo "复制项目文件到 $APP_DIR..."
    cp -r "$PROJECT_ROOT"/* "$APP_DIR/"
fi

# 设置权限
chown -R "$APP_USER:$APP_USER" "$APP_DIR"

echo -e "${GREEN}✓${NC} 应用目录配置完成"
echo ""

# -----------------------------------------------------------------------------
# 4. 配置环境变量
# -----------------------------------------------------------------------------
echo -e "${YELLOW}[4/8] 配置环境变量...${NC}"

if [ ! -f "$APP_DIR/.env" ]; then
    if [ -f "$APP_DIR/.env.example" ]; then
        cp "$APP_DIR/.env.example" "$APP_DIR/.env"
        # 修改为本地配置
        sed -i 's/POSTGRES_SERVER=db/POSTGRES_SERVER=localhost/' "$APP_DIR/.env"
        sed -i 's/ENVIRONMENT=local/ENVIRONMENT=production/' "$APP_DIR/.env"
        echo -e "${YELLOW}!${NC} 已创建 .env 文件，请手动修改密钥和域名配置"
    fi
fi

echo -e "${GREEN}✓${NC} 环境变量配置完成"
echo ""

# -----------------------------------------------------------------------------
# 5. 安装后端
# -----------------------------------------------------------------------------
echo -e "${YELLOW}[5/8] 安装后端依赖...${NC}"

cd "$APP_DIR/backend"

# 创建虚拟环境并安装依赖
sudo -u "$APP_USER" /root/.cargo/bin/uv venv 2>/dev/null || sudo -u "$APP_USER" python3 -m venv .venv
sudo -u "$APP_USER" /root/.cargo/bin/uv sync 2>/dev/null || sudo -u "$APP_USER" .venv/bin/pip install -e .

# 运行数据库迁移
sudo -u "$APP_USER" .venv/bin/alembic upgrade head

# 初始化数据
sudo -u "$APP_USER" .venv/bin/python -m app.initial_data

echo -e "${GREEN}✓${NC} 后端安装完成"
echo ""

# -----------------------------------------------------------------------------
# 6. 构建前端
# -----------------------------------------------------------------------------
echo -e "${YELLOW}[6/8] 构建前端...${NC}"

cd "$APP_DIR/frontend"

# 设置 API URL
echo "VITE_API_URL=https://$API_DOMAIN" > .env.production

# 安装依赖并构建
npm install
npm run build

echo -e "${GREEN}✓${NC} 前端构建完成"
echo ""

# -----------------------------------------------------------------------------
# 7. 配置 systemd 服务
# -----------------------------------------------------------------------------
echo -e "${YELLOW}[7/8] 配置 systemd 服务...${NC}"

# 创建服务文件
cat > /etc/systemd/system/fastapi-backend.service << EOF
[Unit]
Description=FastAPI Backend Service
After=network.target postgresql.service

[Service]
Type=simple
User=$APP_USER
Group=$APP_USER
WorkingDirectory=$APP_DIR/backend
EnvironmentFile=$APP_DIR/.env
Environment="PATH=$APP_DIR/backend/.venv/bin:/usr/local/bin:/usr/bin:/bin"
ExecStart=$APP_DIR/backend/.venv/bin/uvicorn app.main:app --host 127.0.0.1 --port 8000
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# 重载并启动服务
systemctl daemon-reload
systemctl enable fastapi-backend
systemctl start fastapi-backend

echo -e "${GREEN}✓${NC} systemd 服务配置完成"
echo ""

# -----------------------------------------------------------------------------
# 8. 配置 Nginx
# -----------------------------------------------------------------------------
echo -e "${YELLOW}[8/8] 配置 Nginx...${NC}"

# 创建 Nginx 配置
cat > /etc/nginx/sites-available/fastapi-app << EOF
# 后端 API
server {
    listen 80;
    server_name $API_DOMAIN;
    
    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}

# 前端
server {
    listen 80;
    server_name $DASHBOARD_DOMAIN;
    
    root $APP_DIR/frontend/dist;
    index index.html;
    
    location / {
        try_files \$uri \$uri/ /index.html;
    }
    
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2)$ {
        expires 30d;
        add_header Cache-Control "public, immutable";
    }
}
EOF

# 启用站点
ln -sf /etc/nginx/sites-available/fastapi-app /etc/nginx/sites-enabled/

# 删除默认站点
rm -f /etc/nginx/sites-enabled/default

# 测试并重载 Nginx
nginx -t
systemctl reload nginx

echo -e "${GREEN}✓${NC} Nginx 配置完成"
echo ""

# -----------------------------------------------------------------------------
# 完成
# -----------------------------------------------------------------------------
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  部署完成!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "后续步骤:"
echo "  1. 修改 $APP_DIR/.env 中的密钥和配置"
echo "  2. 配置 DNS 记录指向服务器 IP"
echo "  3. 配置 HTTPS:"
echo "     certbot --nginx -d $API_DOMAIN -d $DASHBOARD_DOMAIN -m $CERTBOT_EMAIL"
echo ""
echo "管理命令:"
echo "  查看状态: systemctl status fastapi-backend"
echo "  查看日志: journalctl -u fastapi-backend -f"
echo "  重启服务: systemctl restart fastapi-backend"
echo ""
echo "访问地址 (配置 DNS 后):"
echo "  前端: https://$DASHBOARD_DOMAIN"
echo "  API: https://$API_DOMAIN"
echo "  API 文档: https://$API_DOMAIN/docs"
