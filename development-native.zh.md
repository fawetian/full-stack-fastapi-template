# FastAPI 项目 - 非 Docker 本地开发

本指南说明如何在不使用 Docker 的情况下设置本地开发环境。所有服务（后端、前端、数据库）都直接在系统上运行。

## 环境要求

开始之前，请确保已安装以下软件：

- **Python 3.10+**: [下载](https://www.python.org/downloads/)
- **Node.js 20+**: [下载](https://nodejs.org/) 或使用 [fnm](https://github.com/Schniz/fnm)/[nvm](https://github.com/nvm-sh/nvm)
- **PostgreSQL 14+**: [下载](https://www.postgresql.org/download/)
- **uv** (推荐): [安装](https://docs.astral.sh/uv/)

### macOS 安装

```bash
# 如果未安装 Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 安装依赖
brew install python@3.11 node postgresql@14

# 安装 uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# 启动 PostgreSQL
brew services start postgresql@14
```

### Ubuntu/Debian 安装

```bash
# 更新软件包列表
sudo apt update

# 安装 Python 和 PostgreSQL
sudo apt install -y python3 python3-pip python3-venv postgresql postgresql-contrib

# 安装 Node.js (使用 NodeSource)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# 安装 uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# 启动 PostgreSQL
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

## 快速开始

### 一键配置

运行配置脚本自动完成所有设置：

```bash
./scripts/local/setup-dev.sh
```

此脚本将：
1. 检查系统依赖
2. 从模板创建 `.env` 文件
3. 配置 PostgreSQL 数据库
4. 安装后端依赖 (Python)
5. 安装前端依赖 (Node.js)
6. 运行数据库迁移

### 启动开发服务器

配置完成后，启动开发服务器：

```bash
# 同时启动后端和前端
./scripts/local/start-all.sh

# 或者分别启动：
# 终端 1 - 后端
./scripts/local/start-backend.sh

# 终端 2 - 前端
./scripts/local/start-frontend.sh
```

访问应用：
- **前端**: http://localhost:5173
- **后端 API**: http://localhost:8000
- **API 文档**: http://localhost:8000/docs

## 手动配置

如果你更喜欢手动设置或需要更多控制：

### 1. 配置环境变量

```bash
# 复制示例文件
cp .env.example .env

# 编辑 .env，将 POSTGRES_SERVER 设置为 localhost
# POSTGRES_SERVER=localhost
```

### 2. 配置 PostgreSQL

```bash
# 运行数据库配置脚本
./scripts/local/setup-postgres.sh

# 或手动配置：
# macOS
createuser -s app
createdb app -O app
psql -c "ALTER USER app WITH PASSWORD 'changethis';"

# Linux
sudo -u postgres createuser -s app
sudo -u postgres createdb app -O app
sudo -u postgres psql -c "ALTER USER app WITH PASSWORD 'changethis';"
```

### 3. 安装后端依赖

```bash
cd backend

# 创建虚拟环境并安装依赖
uv sync

# 激活虚拟环境
source .venv/bin/activate

# 运行数据库迁移
alembic upgrade head

# 初始化数据（创建第一个超级用户）
python -m app.initial_data
```

### 4. 安装前端依赖

```bash
cd frontend

# 安装依赖
npm install
```

### 5. 启动开发服务器

```bash
# 后端（在 backend/ 目录）
source .venv/bin/activate
fastapi dev app/main.py

# 前端（在 frontend/ 目录，另一个终端）
npm run dev
```

## 常用命令

### 后端

```bash
cd backend
source .venv/bin/activate

# 启动开发服务器
fastapi dev app/main.py

# 运行测试
pytest

# 创建数据库迁移
alembic revision --autogenerate -m "描述"

# 应用迁移
alembic upgrade head

# 格式化代码
uv run ruff format
uv run ruff check --fix
```

### 前端

```bash
cd frontend

# 启动开发服务器
npm run dev

# 生产构建
npm run build

# 代码检查
npm run lint

# 生成 API 客户端
npm run generate-client
```

### 数据库

```bash
# 连接数据库
psql -h localhost -U app -d app

# 重置数据库（删除并重建）
dropdb app && createdb app -O app
cd backend && alembic upgrade head && python -m app.initial_data
```

## Docker 和非 Docker 模式切换

两种模式使用相同的 `.env` 文件格式。主要区别是 `POSTGRES_SERVER` 的值：

| 模式 | POSTGRES_SERVER |
|------|-----------------|
| Docker | `db`（容器名） |
| 非 Docker | `localhost` |

要切换模式，只需更新 `.env` 文件中的 `POSTGRES_SERVER` 值即可。

## 常见问题

### PostgreSQL 连接问题

**错误**: `connection refused` 或 `could not connect to server`

**解决方案**:
1. 检查 PostgreSQL 是否运行：
   ```bash
   # macOS
   brew services list
   
   # Linux
   sudo systemctl status postgresql
   ```
2. 如果停止了，启动服务：
   ```bash
   # macOS
   brew services start postgresql
   
   # Linux
   sudo systemctl start postgresql
   ```

### Python 虚拟环境问题

**错误**: `No module named 'app'` 或导入错误

**解决方案**:
1. 确保在虚拟环境中：
   ```bash
   cd backend
   source .venv/bin/activate
   ```
2. 重新安装依赖：
   ```bash
   uv sync
   ```

### 前端构建问题

**错误**: `VITE_API_URL is not defined`

**解决方案**:
启动前设置环境变量：
```bash
export VITE_API_URL=http://localhost:8000
npm run dev
```

### 端口被占用

**错误**: `Address already in use`

**解决方案**:
找到并结束占用端口的进程：
```bash
# 查找使用 8000 端口的进程
lsof -i :8000

# 结束进程
kill -9 <PID>
```

## IDE 配置

### VS Code

项目包含 VS Code 调试配置。在 VS Code 中打开项目后，你可以：

1. **调试后端**: 使用 "Python: FastAPI" 调试配置
2. **运行测试**: 使用 VS Code Python 测试浏览器

### PyCharm

1. 将 Python 解释器设置为 `backend/.venv/bin/python`
2. 将 `backend` 标记为 Sources Root
3. 配置运行配置使用 `fastapi dev app/main.py`
