# FastAPI Project - Native Deployment (Non-Docker)

This guide explains how to deploy the FastAPI project to a Linux server without using Docker, using systemd for process management and Nginx as a reverse proxy.

## Architecture Overview

```
                     Internet
                        │
                        ▼
              ┌─────────────────┐
              │     Nginx       │
              │  (Reverse Proxy)│
              │   Port 80/443   │
              └────────┬────────┘
                       │
         ┌─────────────┴─────────────┐
         ▼                           ▼
┌─────────────────┐        ┌─────────────────┐
│  FastAPI Backend│        │    Frontend     │
│  (uvicorn)      │        │  (Static Files) │
│  127.0.0.1:8000 │        │   /dist folder  │
└────────┬────────┘        └─────────────────┘
         │
         ▼
┌─────────────────┐
│   PostgreSQL    │
│   localhost     │
│   Port 5432     │
└─────────────────┘
```

## Prerequisites

- Ubuntu 20.04+ or Debian 11+ server
- Domain name pointed to server IP
- SSH access with sudo privileges

## Quick Deployment

### One-Command Deploy

Upload your project to the server and run:

```bash
sudo bash scripts/deploy/deploy-native.sh
```

This script will:
1. Install system dependencies
2. Configure PostgreSQL
3. Set up the application
4. Configure systemd service
5. Configure Nginx

After deployment, configure HTTPS:

```bash
sudo certbot --nginx -d api.your-domain.com -d dashboard.your-domain.com
```

## Manual Deployment

### 1. Prepare Server

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install dependencies
sudo apt install -y \
    python3 python3-pip python3-venv \
    postgresql postgresql-contrib \
    nginx \
    certbot python3-certbot-nginx \
    curl git build-essential

# Install Node.js 20
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### 2. Configure PostgreSQL

```bash
# Start PostgreSQL
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Create database user and database
sudo -u postgres createuser -s app
sudo -u postgres createdb app -O app
sudo -u postgres psql -c "ALTER USER app WITH PASSWORD 'your-secure-password';"
```

### 3. Set Up Application

```bash
# Create application directory
sudo mkdir -p /var/www/fastapi-app
cd /var/www/fastapi-app

# Clone or upload your project
git clone https://github.com/your-repo/your-project.git .

# Or upload via rsync
# rsync -avz --exclude '.git' --exclude 'node_modules' --exclude '.venv' ./ user@server:/var/www/fastapi-app/

# Create and configure .env
cp .env.example .env
nano .env  # Edit with production values
```

**Important `.env` settings for production:**

```bash
ENVIRONMENT=production
POSTGRES_SERVER=localhost
SECRET_KEY=<generate-secure-key>
FIRST_SUPERUSER_PASSWORD=<secure-password>
POSTGRES_PASSWORD=<your-db-password>
```

Generate a secure key:

```bash
python3 -c "import secrets; print(secrets.token_urlsafe(32))"
```

### 4. Install Backend

```bash
cd /var/www/fastapi-app/backend

# Create virtual environment
uv venv
# Or: python3 -m venv .venv

# Install dependencies
uv sync
# Or: .venv/bin/pip install -e .

# Run migrations
.venv/bin/alembic upgrade head

# Initialize data
.venv/bin/python -m app.initial_data

# Set permissions
sudo chown -R www-data:www-data /var/www/fastapi-app
```

### 5. Build Frontend

```bash
cd /var/www/fastapi-app/frontend

# Set API URL for production
echo "VITE_API_URL=https://api.your-domain.com" > .env.production

# Install dependencies and build
npm install
npm run build
```

### 6. Configure systemd Service

Create the service file:

```bash
sudo nano /etc/systemd/system/fastapi-backend.service
```

Content:

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

Enable and start the service:

```bash
sudo systemctl daemon-reload
sudo systemctl enable fastapi-backend
sudo systemctl start fastapi-backend

# Check status
sudo systemctl status fastapi-backend
```

### 7. Configure Nginx

Create Nginx configuration:

```bash
sudo nano /etc/nginx/sites-available/fastapi-app
```

Content:

```nginx
# Backend API
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

# Frontend
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

Enable the site:

```bash
sudo ln -s /etc/nginx/sites-available/fastapi-app /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default  # Remove default site
sudo nginx -t
sudo systemctl reload nginx
```

### 8. Configure HTTPS

```bash
sudo certbot --nginx -d api.your-domain.com -d dashboard.your-domain.com

# Test auto-renewal
sudo certbot renew --dry-run
```

## Daily Operations

### Service Management

```bash
# Check status
sudo systemctl status fastapi-backend

# View logs
sudo journalctl -u fastapi-backend -f

# Restart service
sudo systemctl restart fastapi-backend

# Stop service
sudo systemctl stop fastapi-backend
```

### Update Deployment

Use the update script for quick updates:

```bash
sudo bash scripts/deploy/update-native.sh
```

Or manually:

```bash
cd /var/www/fastapi-app

# Pull latest code
git pull

# Update backend
cd backend
uv sync
.venv/bin/alembic upgrade head

# Rebuild frontend
cd ../frontend
npm install
npm run build

# Restart service
sudo systemctl restart fastapi-backend
```

### Database Backup

```bash
# Create backup
sudo -u postgres pg_dump app > backup_$(date +%Y%m%d_%H%M%S).sql

# Restore backup
sudo -u postgres psql app < backup_file.sql
```

### View Logs

```bash
# Backend logs
sudo journalctl -u fastapi-backend -f

# Nginx access logs
sudo tail -f /var/log/nginx/access.log

# Nginx error logs
sudo tail -f /var/log/nginx/error.log

# PostgreSQL logs
sudo tail -f /var/log/postgresql/postgresql-*-main.log
```

## Security Recommendations

1. **Firewall**: Enable UFW and allow only necessary ports
   ```bash
   sudo ufw allow ssh
   sudo ufw allow 'Nginx Full'
   sudo ufw enable
   ```

2. **Fail2ban**: Install to prevent brute force attacks
   ```bash
   sudo apt install fail2ban
   sudo systemctl enable fail2ban
   ```

3. **Automatic Updates**: Enable unattended upgrades
   ```bash
   sudo apt install unattended-upgrades
   sudo dpkg-reconfigure -plow unattended-upgrades
   ```

4. **Strong Passwords**: Use generated passwords for:
   - `SECRET_KEY`
   - `POSTGRES_PASSWORD`
   - `FIRST_SUPERUSER_PASSWORD`

## Troubleshooting

### Backend Won't Start

Check the service logs:
```bash
sudo journalctl -u fastapi-backend -n 50
```

Common issues:
- Missing environment variables in `.env`
- Database connection failed
- Python dependencies not installed

### 502 Bad Gateway

The backend service is not running:
```bash
sudo systemctl status fastapi-backend
sudo systemctl start fastapi-backend
```

### Database Connection Refused

Check PostgreSQL status:
```bash
sudo systemctl status postgresql
sudo systemctl start postgresql
```

### Permission Denied

Fix ownership:
```bash
sudo chown -R www-data:www-data /var/www/fastapi-app
```

## File Structure

```
/var/www/fastapi-app/
├── .env                    # Environment variables
├── backend/
│   ├── .venv/             # Python virtual environment
│   ├── app/               # Application code
│   └── alembic/           # Database migrations
├── frontend/
│   ├── dist/              # Built frontend (served by Nginx)
│   └── src/               # Source code
└── scripts/
    └── deploy/            # Deployment scripts

/etc/systemd/system/
└── fastapi-backend.service

/etc/nginx/sites-available/
└── fastapi-app
```
