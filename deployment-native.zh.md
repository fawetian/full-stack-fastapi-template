# FastAPI 项目 - 非 Docker 部署

本指南说明如何在不使用 Docker 的情况下将 FastAPI 项目部署到 Linux 服务器，使用 systemd 进行进程管理，Nginx 作为反向代理。

## 架构概览

```
                     互联网
                        │
                        ▼
              ┌─────────────────┐
              │     Nginx       │
              │   (反向代理)     │
              │   端口 80/443   │
              └────────┬────────┘
                       │
         ┌─────────────┴─────────────┐
         ▼                           ▼
┌─────────────────┐        ┌─────────────────┐
│  FastAPI 后端   │        │      前端       │
│  (uvicorn)      │        │  (静态文件)     │
│  127.0.0.1:8000 │        │   /dist 目录    │
└────────┬────────┘        └─────────────────┘
         │
         ▼
┌─────────────────┐
│   PostgreSQL    │
│   localhost     │
│   端口 5432     │
└─────────────────┘
```

## 前置条件

- Ubuntu 20.04+ 或 Debian 11+ 服务器
- 域名已指向服务器 IP
- 具有 sudo 权限的 SSH 访问

## 快速部署

### 一键部署

将项目上传到服务器后运行：

```bash
sudo bash scripts/deploy/deploy-native.sh
```

此脚本将：
1. 安装系统依赖
2. 配置 PostgreSQL
3. 设置应用程序
4. 配置 systemd 服务
5. 配置 Nginx

部署后，配置 HTTPS：

```bash
sudo certbot --nginx -d api.your-domain.com -d dashboard.your-domain.com
```

## 手动部署

### 1. 准备服务器

```bash
# 更新系统
sudo apt update && sudo apt upgrade -y

# 安装依赖
sudo apt install -y \
    python3 python3-pip python3-venv \
    postgresql postgresql-contrib \
    nginx \
    certbot python3-certbot-nginx \
    curl git build-essential

# 安装 Node.js 20
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# 安装 uv
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### 2. 配置 PostgreSQL

```bash
# 启动 PostgreSQL
sudo systemctl start postgresql
sudo systemctl enable postgresql

# 创建数据库用户和数据库
sudo -u postgres createuser -s app
sudo -u postgres createdb app -O app
sudo -u postgres psql -c "ALTER USER app WITH PASSWORD 'your-secure-password';"
```

### 3. 设置应用程序

```bash
# 创建应用目录
sudo mkdir -p /var/www/fastapi-app
cd /var/www/fastapi-app

# 克隆或上传项目
git clone https://github.com/your-repo/your-project.git .

# 或通过 rsync 上传
# rsync -avz --exclude '.git' --exclude 'node_modules' --exclude '.venv' ./ user@server:/var/www/fastapi-app/

# 创建并配置 .env
cp .env.example .env
nano .env  # 编辑生产环境值
```

**生产环境重要的 `.env` 设置：**

```bash
ENVIRONMENT=production
POSTGRES_SERVER=localhost
SECRET_KEY=<生成安全密钥>
FIRST_SUPERUSER_PASSWORD=<安全密码>
POSTGRES_PASSWORD=<数据库密码>
```

生成安全密钥：

```bash
python3 -c "import secrets; print(secrets.token_urlsafe(32))"
```

### 4. 安装后端

```bash
cd /var/www/fastapi-app/backend

# 创建虚拟环境
uv venv
# 或: python3 -m venv .venv

# 安装依赖
uv sync
# 或: .venv/bin/pip install -e .

# 运行迁移
.venv/bin/alembic upgrade head

# 初始化数据
.venv/bin/python -m app.initial_data

# 设置权限
sudo chown -R www-data:www-data /var/www/fastapi-app
```

### 5. 构建前端

```bash
cd /var/www/fastapi-app/frontend

# 设置生产环境 API URL
echo "VITE_API_URL=https://api.your-domain.com" > .env.production

# 安装依赖并构建
npm install
npm run build
```

### 6. 配置 systemd 服务

创建服务文件：

```bash
sudo nano /etc/systemd/system/fastapi-backend.service
```

内容：

```ini
[Unit]
Description=FastAPI Backend Service
After=network.target postgresql.service

[Service]
Type=simple
User=www-data
Group=www-data
WorkingDirectory=/var/www/fastapi-app/backend
EnvironmentFile=/var/www/fastapi-app/.env
Environment="PATH=/var/www/fastapi-app/backend/.venv/bin"
ExecStart=/var/www/fastapi-app/backend/.venv/bin/uvicorn app.main:app --host 127.0.0.1 --port 8000
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

启用并启动服务：

```bash
sudo systemctl daemon-reload
sudo systemctl enable fastapi-backend
sudo systemctl start fastapi-backend

# 检查状态
sudo systemctl status fastapi-backend
```

### 7. 配置 Nginx

创建 Nginx 配置：

```bash
sudo nano /etc/nginx/sites-available/fastapi-app
```

内容：

```nginx
# 后端 API
server {
    listen 80;
    server_name api.your-domain.com;
    
    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

# 前端
server {
    listen 80;
    server_name dashboard.your-domain.com;
    
    root /var/www/fastapi-app/frontend/dist;
    index index.html;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2)$ {
        expires 30d;
        add_header Cache-Control "public, immutable";
    }
}
```

启用站点：

```bash
sudo ln -s /etc/nginx/sites-available/fastapi-app /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default  # 删除默认站点
sudo nginx -t
sudo systemctl reload nginx
```

### 8. 配置 HTTPS

```bash
sudo certbot --nginx -d api.your-domain.com -d dashboard.your-domain.com

# 测试自动续期
sudo certbot renew --dry-run
```

## 日常运维

### 服务管理

```bash
# 查看状态
sudo systemctl status fastapi-backend

# 查看日志
sudo journalctl -u fastapi-backend -f

# 重启服务
sudo systemctl restart fastapi-backend

# 停止服务
sudo systemctl stop fastapi-backend
```

### 更新部署

使用更新脚本快速更新：

```bash
sudo bash scripts/deploy/update-native.sh
```

或手动更新：

```bash
cd /var/www/fastapi-app

# 拉取最新代码
git pull

# 更新后端
cd backend
uv sync
.venv/bin/alembic upgrade head

# 重新构建前端
cd ../frontend
npm install
npm run build

# 重启服务
sudo systemctl restart fastapi-backend
```

### 数据库备份

```bash
# 创建备份
sudo -u postgres pg_dump app > backup_$(date +%Y%m%d_%H%M%S).sql

# 恢复备份
sudo -u postgres psql app < backup_file.sql
```

### 查看日志

```bash
# 后端日志
sudo journalctl -u fastapi-backend -f

# Nginx 访问日志
sudo tail -f /var/log/nginx/access.log

# Nginx 错误日志
sudo tail -f /var/log/nginx/error.log

# PostgreSQL 日志
sudo tail -f /var/log/postgresql/postgresql-*-main.log
```

## 安全建议

1. **防火墙**: 启用 UFW 并只允许必要端口
   ```bash
   sudo ufw allow ssh
   sudo ufw allow 'Nginx Full'
   sudo ufw enable
   ```

2. **Fail2ban**: 安装以防止暴力攻击
   ```bash
   sudo apt install fail2ban
   sudo systemctl enable fail2ban
   ```

3. **自动更新**: 启用无人值守升级
   ```bash
   sudo apt install unattended-upgrades
   sudo dpkg-reconfigure -plow unattended-upgrades
   ```

4. **强密码**: 为以下配置使用生成的密码：
   - `SECRET_KEY`
   - `POSTGRES_PASSWORD`
   - `FIRST_SUPERUSER_PASSWORD`

## 故障排查

### 后端无法启动

检查服务日志：
```bash
sudo journalctl -u fastapi-backend -n 50
```

常见问题：
- `.env` 中缺少环境变量
- 数据库连接失败
- Python 依赖未安装

### 502 Bad Gateway

后端服务未运行：
```bash
sudo systemctl status fastapi-backend
sudo systemctl start fastapi-backend
```

### 数据库连接被拒绝

检查 PostgreSQL 状态：
```bash
sudo systemctl status postgresql
sudo systemctl start postgresql
```

### 权限被拒绝

修复所有权：
```bash
sudo chown -R www-data:www-data /var/www/fastapi-app
```

## 文件结构

```
/var/www/fastapi-app/
├── .env                    # 环境变量
├── backend/
│   ├── .venv/             # Python 虚拟环境
│   ├── app/               # 应用代码
│   └── alembic/           # 数据库迁移
├── frontend/
│   ├── dist/              # 构建的前端（由 Nginx 服务）
│   └── src/               # 源代码
└── scripts/
    └── deploy/            # 部署脚本

/etc/systemd/system/
└── fastapi-backend.service

/etc/nginx/sites-available/
└── fastapi-app
```
