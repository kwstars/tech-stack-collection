#!/bin/bash

declare -A dashboards

# 定义一个关联数组, 可以理解为 Python 的字典
dashboards=(
  ["demo.json"]=http://127.0.0.1
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
  echo "{\"dashboard\": $(cat dashboards/$dashboard),\"overwrite\": false}" >temp.json
  curl -X POST -H "Content-Type: application/json" -d @temp.json http://admin:admin@localhost:13000/api/dashboards/db
  rm temp.json
done
