#!/usr/bin/env bash
set -E -e -u -o pipefail

# 设置目标目录
PLUGIN_DIR="$HOME/.local/share/nvim/lazy"
ONE_YEAR_AGO=$(date -d "2 year ago" +%s)

echo "Checking plugins in $PLUGIN_DIR for updates older than 1 year..."
echo "---------------------------------------------------------------"

# 遍历目录下的所有子目录
for repo in "$PLUGIN_DIR"/*; do
  if [ -d "$repo/.git" ]; then
    # 获取插件名称（目录名）
    plugin_name=$(basename "$repo")
    
    # 进入 Git 仓库目录
    pushd "$repo" > /dev/null
    
    # 获取最后提交的时间戳
    last_commit_timestamp=$(git log -1 --format=%ct 2>/dev/null)
    
    if [ -n "$last_commit_timestamp" ]; then
      # 转换为可读日期
      last_commit_date=$(date -d "@$last_commit_timestamp" "+%Y-%m-%d")
      
      # 检查是否超过一年未更新
      if [ "$last_commit_timestamp" -lt "$ONE_YEAR_AGO" ]; then
        echo "Plugin: $plugin_name"
        echo "Last commit: $last_commit_date"
        echo "Repository: $(git config --get remote.origin.url)"
        echo "---------------------------------------------------------------"
      fi
    else
      echo "Plugin: $plugin_name"
      echo "Warning: Could not retrieve commit history"
      echo "Repository: $(git config --get remote.origin.url)"
      echo "---------------------------------------------------------------"
    fi
    
    # 返回上一级目录
    popd > /dev/null
  fi
done

echo "Check complete."
