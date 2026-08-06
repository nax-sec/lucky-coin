#!/bin/bash
# 由 source/index.html（片段）生成可独立部署的 index.html（完整文档）
# 片段没有 <head>，Artifact 平台会自动补；GitHub Pages 不会，必须自己包壳，
# 否则中文按错误编码解析，连 JS 都可能报 "missing ) after argument list"。
set -e
cd "$(dirname "$0")"

{
cat <<'HEAD'
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="description" content="幸运硬币 —— 当铺主题的老虎机 roguelike。拉下拉杆，凑出你自己的符号组合，赶在房东上门前把租金挣出来。">
<meta name="theme-color" content="#0A0C11">
<link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🪙</text></svg>">
<style>html,body{margin:0;padding:0}</style>
</head>
<body>
HEAD
cat source/index.html
cat <<'FOOT'
</body>
</html>
FOOT
} > index.html

echo "已生成 index.html（$(wc -c < index.html) 字节）"
