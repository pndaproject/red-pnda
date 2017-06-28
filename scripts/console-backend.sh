#!/bin/bash
cd /opt/pnda

# if directory & soft links present, delete it
rm -r platform-console-backend-develop >/dev/null 2>&1
rm console-backend-data-logger >/dev/null 2>&1
rm console-backend-data-manager >/dev/null 2>&1
rm console-backend-utils >/dev/null 2>&1

wget https://github.com/pndaproject/platform-console-backend/archive/develop.zip
unzip develop.zip
rm develop.zip

# console-backend-utils
ln -s /opt/pnda/platform-console-backend-develop/console-backend-utils /opt/pnda/console-backend-utils
cd /opt/pnda/console-backend-utils
npm install

cd /opt/pnda
# console-backend-data-logger
ln -s /opt/pnda/platform-console-backend-develop/console-backend-data-logger /opt/pnda/console-backend-data-logger
cd /opt/pnda/console-backend-data-logger
npm install

cp -r /opt/pnda/console-backend-utils ./

# upstart script for data-logger
cp $1/scripts/files/data-logger.conf /etc/init/

sudo service data-logger start

# console-backend-data-manager
cd /opt/pnda
ln -s /opt/pnda/platform-console-backend-develop/console-backend-data-manager /opt/pnda/console-backend-data-manager
cd /opt/pnda/console-backend-data-manager
npm install

cp -r /opt/pnda/console-backend-utils ./

rm ./conf/config.js

cat <<EOF >  ./conf/config.js
var hostname = process.env.HOSTNAME || 'localhost';
var whitelist = ['http://localhost', 'http://' + hostname, 'http://' + hostname + ':8006', 'http://0.0.0.0:8006'];
module.exports = {
  whitelist: whitelist,
  deployment_manager: {
    host: "http://127.0.0.1:5000",
    API: {
      endpoints: "/environment/endpoints",
      packages_available: "/repository/packages?recency=999",
      packages: "/packages",
      applications: "/applications"
    }
  },
  dataset_manager: {
    host: "http://127.0.0.1:7000",
    API: {
      datasets: "/api/v1/datasets"
    }
  }
};
EOF

# upstart script for data-manager
cp $1/scripts/files/data-manager.conf /etc/init/

sudo service data-manager start