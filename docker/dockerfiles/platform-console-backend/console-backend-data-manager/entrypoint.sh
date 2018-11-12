#/bin/sh
j2 /backend_data_manager_conf.js.tpl > /console-backend-data-manager/conf/config.js
node /console-backend-data-manager/app.js
