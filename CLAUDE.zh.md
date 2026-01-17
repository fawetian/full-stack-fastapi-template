# CLAUDE.md

此文件为 Claude Code (claude.ai/code) 在处理此仓库中的代码时提供指导。

## 项目概述

Full Stack FastAPI Template - 一个生产就绪的 Web 应用程序，具有 FastAPI 后端、React 前端、PostgreSQL 数据库和 Docker Compose 编排。

## 常用命令

### 开发

```bash
# 使用 Docker Compose 启动完整堆栈（推荐）
docker compose watch

# 查看日志
docker compose logs backend
docker compose logs frontend
```

### 后端（从 backend/ 目录）

```bash
# 安装依赖
uv sync

# 激活虚拟环境
source .venv/bin/activate

# 运行本地开发服务器（不使用 Docker）
fastapi dev app/main.py

# 在 Docker 中运行测试（从项目根目录）
docker compose exec backend bash scripts/tests-start.sh

# 运行单个测试
docker compose exec backend bash scripts/tests-start.sh -x tests/path/to/test.py::test_name

# 运行带覆盖率的测试（在容器内）
bash scripts/test.sh

# 创建数据库迁移
alembic revision --autogenerate -m "Description"

# 应用迁移
alembic upgrade head
```

### 前端（从 frontend/ 目录）

```bash
# 安装依赖
npm install

# 运行本地开发服务器
npm run dev

# 代码检查和格式化
npm run lint

# 构建
npm run build

# 从 OpenAPI 规范生成 API 客户端
npm run generate-client

# 运行 E2E 测试（需要后端运行）
npx playwright test
```

### 代码质量

```bash
# 安装预提交钩子（从 backend/）
uv run prek install -f

# 手动运行所有预提交检查
uv run prek run --all-files

# 后端代码检查
uv run ruff check --fix
uv run ruff format

# 前端代码检查
cd frontend && npm run lint
```

### 生成前端客户端

```bash
# 从项目根目录（需要后端 venv 激活）
./scripts/generate-client.sh
```

## 架构

### 后端结构 (backend/app/)

- `main.py` - FastAPI 应用初始化、CORS、Sentry 设置
- `models.py` - SQLModel 数据库模型和 Pydantic 模式（User、Item、Token）
- `crud.py` - 数据库 CRUD 操作
- `core/config.py` - 通过 pydantic-settings 进行设置（从 ../.env 读取）
- `core/db.py` - 数据库会话管理
- `core/security.py` - 密码哈希、JWT 令牌处理
- `api/main.py` - API 路由器聚合
- `api/routes/` - 端点模块（login、users、items、utils、private）
- `api/deps.py` - FastAPI 依赖项（auth、db 会话）
- `alembic/` - 数据库迁移

### 前端结构 (frontend/src/)

- `main.tsx` - 应用入口点
- `client/` - 自动生成的 OpenAPI 客户端（后端 API 更改后重新生成）
- `components/` - 使用 shadcn/ui 的 React 组件
- `routes/` - TanStack Router 基于文件的路由
- `hooks/` - 自定义 React hooks
- `routeTree.gen.ts` - 自动生成的路由树

### 关键模式

- **API 版本控制**：所有端点都在 `/api/v1` 下
- **身份验证**：通过 `/api/v1/login/access-token` 的 JWT 令牌
- **数据库模型**：SQLModel 类，`table=True` 用于 DB 表，不使用用于 Pydantic 模式
- **前端状态**：TanStack Query 用于服务器状态，React Hook Form 用于表单
- **样式**：Tailwind CSS 和 shadcn/ui 组件

### 开发 URL

- 前端：http://localhost:5173
- 后端 API：http://localhost:8000
- API 文档（Swagger）：http://localhost:8000/docs
- Adminer（DB 管理）：http://localhost:8080
- MailCatcher：http://localhost:1080

## 配置

环境变量在项目根目录的 `.env` 中。关键设置：
- `SECRET_KEY`、`POSTGRES_PASSWORD`、`FIRST_SUPERUSER_PASSWORD` - 对于非本地环境，必须从 "changethis" 更改
- 后端通过 `backend/app/core/config.py` 中的 `pydantic-settings` 读取配置
