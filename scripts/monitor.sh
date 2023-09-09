#!/usr/bin/env bash

set -E -e -u -o pipefail

cd ~/core
git clone https://github.com/VictoriaMetrics/VictoriaMetrics
cd VictoriaMetrics/deployment/docker
docker compose up -d
# docker compose down # 删除
echo "default user/passwd : admin admin"
google-chrome-stable 127.0.0.1:3000
