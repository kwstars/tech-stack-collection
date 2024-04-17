#!/bin/bash

declare -A dashboards

# 定义一个关联数组, 可以理解为 Python 的字典
dashboards=(
  ["node.json"]="https://grafana.com/api/dashboards/1860/revisions/36/download"
  ["redis.json"]="https://grafana.com/api/dashboards/11835/revisions/1/download"
)

# echo ${dashboards["node.json"]}

if [ ! -d dashboards ]; then
  mkdir -p dashboards
fi

# ${!array[@]} 或 ${!array[*]} 是一种特殊的数组语法，用于获取数组的所有键。
for dashboard in "${!dashboards[@]}"; do
  if [ ! -f "dashboards/$dashboard" ]; then
    curl -o "dashboards/$dashboard" "${dashboards[$dashboard]}"
  fi
  echo "{\"dashboard\": $(cat dashboards/$dashboard)}" >temp.json
  curl -X POST -H "Content-Type: application/json" -d @temp.json http://admin:admin@localhost:3000/api/dashboards/db
  rm temp.json
done
