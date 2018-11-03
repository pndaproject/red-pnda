#/bin/sh
j2 /logger.json.tpl > /console-backend-data-logger/conf/logger.json
node /console-backend-data-logger/app.js
