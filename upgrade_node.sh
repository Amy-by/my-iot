#!/usr/bin/env bash
#
# 一键升级 Node 到 20.x 并重装依赖、启动 dev（需 sudo 权限时会提示）。
# 适用：Debian/Ubuntu 系发行版。
#
set -e

PROJECT_ROOT="/var/ctt_wkplace/my-iot"

echo "==> 检查 curl..."
if ! command -v curl >/dev/null 2>&1; then
  echo "安装 curl..."
  sudo apt-get update
  sudo apt-get install -y curl
fi

echo "==> 设置 NodeSource 20.x 源..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -

echo "==> 安装 nodejs 20.x ..."
sudo apt-get install -y nodejs

echo "==> 版本确认:"
node -v
npm -v

echo "==> 安装依赖 (npm install)..."
cd "$PROJECT_ROOT"
npm install

echo "==> 启动开发服务器 (npm run dev)..."
echo "如需后台运行，可手动执行：cd $PROJECT_ROOT && npm run dev"
npm run dev


