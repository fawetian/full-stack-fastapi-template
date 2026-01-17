# FastAPI Project - Native Development (Non-Docker)

This guide explains how to set up a local development environment without using Docker. All services (backend, frontend, database) run directly on your system.

## Prerequisites

Before you begin, ensure you have the following installed:

- **Python 3.10+**: [Download](https://www.python.org/downloads/)
- **Node.js 20+**: [Download](https://nodejs.org/) or use [fnm](https://github.com/Schniz/fnm)/[nvm](https://github.com/nvm-sh/nvm)
- **PostgreSQL 14+**: [Download](https://www.postgresql.org/download/)
- **uv** (recommended): [Install](https://docs.astral.sh/uv/)

### Install on macOS

```bash
# Install Homebrew if not installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install dependencies
brew install python@3.11 node postgresql@14

# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# Start PostgreSQL
brew services start postgresql@14
```

### Install on Ubuntu/Debian

```bash
# Update package list
sudo apt update

# Install Python and PostgreSQL
sudo apt install -y python3 python3-pip python3-venv postgresql postgresql-contrib

# Install Node.js (using NodeSource)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# Start PostgreSQL
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

## Quick Start

### One-Command Setup

Run the setup script to configure everything automatically:

```bash
./scripts/local/setup-dev.sh
```

This script will:
1. Check system dependencies
2. Create `.env` file from template
3. Configure PostgreSQL database
4. Install backend dependencies (Python)
5. Install frontend dependencies (Node.js)
6. Run database migrations

### Start Development Servers

After setup, start the development servers:

```bash
# Start both backend and frontend
./scripts/local/start-all.sh

# Or start them separately:
# Terminal 1 - Backend
./scripts/local/start-backend.sh

# Terminal 2 - Frontend
./scripts/local/start-frontend.sh
```

Access the application:
- **Frontend**: http://localhost:5173
- **Backend API**: http://localhost:8000
- **API Documentation**: http://localhost:8000/docs

## Manual Setup

If you prefer to set up manually or need more control:

### 1. Configure Environment Variables

```bash
# Copy the example file
cp .env.example .env

# Edit .env and set POSTGRES_SERVER to localhost
# POSTGRES_SERVER=localhost
```

### 2. Set Up PostgreSQL

```bash
# Run the database setup script
./scripts/local/setup-postgres.sh

# Or manually:
# macOS
createuser -s app
createdb app -O app
psql -c "ALTER USER app WITH PASSWORD 'changethis';"

# Linux
sudo -u postgres createuser -s app
sudo -u postgres createdb app -O app
sudo -u postgres psql -c "ALTER USER app WITH PASSWORD 'changethis';"
```

### 3. Install Backend Dependencies

```bash
cd backend

# Create virtual environment and install dependencies
uv sync

# Activate virtual environment
source .venv/bin/activate

# Run database migrations
alembic upgrade head

# Initialize data (create first superuser)
python -m app.initial_data
```

### 4. Install Frontend Dependencies

```bash
cd frontend

# Install dependencies
npm install
```

### 5. Start Development Servers

```bash
# Backend (from backend/ directory)
source .venv/bin/activate
fastapi dev app/main.py

# Frontend (from frontend/ directory, in another terminal)
npm run dev
```

## Common Commands

### Backend

```bash
cd backend
source .venv/bin/activate

# Start development server
fastapi dev app/main.py

# Run tests
pytest

# Create database migration
alembic revision --autogenerate -m "Description"

# Apply migrations
alembic upgrade head

# Format code
uv run ruff format
uv run ruff check --fix
```

### Frontend

```bash
cd frontend

# Start development server
npm run dev

# Build for production
npm run build

# Lint code
npm run lint

# Generate API client
npm run generate-client
```

### Database

```bash
# Connect to database
psql -h localhost -U app -d app

# Reset database (drop and recreate)
dropdb app && createdb app -O app
cd backend && alembic upgrade head && python -m app.initial_data
```

## Switching Between Docker and Native

Both modes use the same `.env` file format. The main difference is the `POSTGRES_SERVER` value:

| Mode | POSTGRES_SERVER |
|------|-----------------|
| Docker | `db` (container name) |
| Native | `localhost` |

To switch modes, simply update the `POSTGRES_SERVER` value in your `.env` file.

## Troubleshooting

### PostgreSQL Connection Issues

**Error**: `connection refused` or `could not connect to server`

**Solution**:
1. Check if PostgreSQL is running:
   ```bash
   # macOS
   brew services list
   
   # Linux
   sudo systemctl status postgresql
   ```
2. Start the service if stopped:
   ```bash
   # macOS
   brew services start postgresql
   
   # Linux
   sudo systemctl start postgresql
   ```

### Python Virtual Environment Issues

**Error**: `No module named 'app'` or import errors

**Solution**:
1. Ensure you're in the virtual environment:
   ```bash
   cd backend
   source .venv/bin/activate
   ```
2. Reinstall dependencies:
   ```bash
   uv sync
   ```

### Frontend Build Issues

**Error**: `VITE_API_URL is not defined`

**Solution**:
Set the environment variable before starting:
```bash
export VITE_API_URL=http://localhost:8000
npm run dev
```

### Port Already in Use

**Error**: `Address already in use`

**Solution**:
Find and kill the process using the port:
```bash
# Find process on port 8000
lsof -i :8000

# Kill the process
kill -9 <PID>
```

## IDE Configuration

### VS Code

The project includes VS Code configurations for debugging. Open the project in VS Code, and you can:

1. **Debug Backend**: Use the "Python: FastAPI" debug configuration
2. **Run Tests**: Use the VS Code Python test explorer

### PyCharm

1. Set the Python interpreter to `backend/.venv/bin/python`
2. Mark `backend` as Sources Root
3. Configure the run configuration to use `fastapi dev app/main.py`
