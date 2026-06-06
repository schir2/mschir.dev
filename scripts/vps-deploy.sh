#!/usr/bin/env bash
set -euo pipefail

APP_DIR="/apps/mschir.dev"
ECOSYSTEM="/apps/ecosystem.config.js"

cd "$APP_DIR"

echo "==> Pulling latest..."
git pull

echo "==> Installing dependencies..."
pnpm install --frozen-lockfile

echo "==> Building..."
set -a; [ -f .env ] && source .env; set +a
pnpm run build

echo "==> Reloading pm2..."
pm2 reload mschir 2>/dev/null || (pm2 start "$ECOSYSTEM" --only mschir && pm2 save)

echo "==> Done."
