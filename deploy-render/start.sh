#!/bin/sh
set -e

export DATA_DIR="${DATA_DIR:-/data}"
mkdir -p "$DATA_DIR"

echo "Starting nginx on port 8080..."
nginx -g "daemon off;" &

echo "Starting API on port 3000 (data dir: $DATA_DIR)..."
exec env PORT=3000 node /app/api/server.js
