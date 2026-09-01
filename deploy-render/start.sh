#!/bin/sh
set -e

export PORT="${PORT:-3000}"
export DATA_DIR="${DATA_DIR:-/data}"
mkdir -p "$DATA_DIR"

echo "Starting API on port $PORT (data dir: $DATA_DIR)..."
node /app/api/server.js &

echo "Starting nginx on port 8080..."
exec nginx -g "daemon off;"
