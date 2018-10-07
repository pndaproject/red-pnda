#!/bin/bash
set -e

[ "$#" -ne 1 ] && echo "Missing template filename" && exit 1

TEMP_FILE="/tmp/grafana-dashboard.json"

JSON_PREFIX='{ "inputs": [
  {
    "type": "datasource",
    "pluginId": "graphite",
    "name": "DS_PNDA_GRAPHITE",
    "value": "PNDA Graphite"
  }
 ],
 "dashboard": '
JSON_SUFFIX=', "overwrite": true }'

echo "${JSON_PREFIX}" > "${TEMP_FILE}"
cat "$1" >> "${TEMP_FILE}"
echo "${JSON_SUFFIX}" >> "${TEMP_FILE}"

curl -H "Content-Type: application/json" -X POST -d @"${TEMP_FILE}" http://pnda:pnda@grafana:3000/api/dashboards/import
