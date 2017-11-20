#!/bin/bash

set -e
set -x
source ../utils.sh

cd $MAIN_DIR

# if directory & soft links present, delete it
rm -r platform-console-backend-develop >/dev/null 2>&1 || true
rm console-backend-data-logger >/dev/null 2>&1 || true
rm console-backend-data-manager >/dev/null 2>&1 || true
rm console-backend-utils >/dev/null 2>&1 || true

wget https://github.com/pndaproject/platform-console-backend/archive/develop.zip
unzip develop.zip
rm develop.zip

# console-backend-utils
ln -s $MAIN_DIR/platform-console-backend-develop/console-backend-utils $MAIN_DIR/console-backend-utils
cd $MAIN_DIR/console-backend-utils
npm install

cd $MAIN_DIR
# console-backend-data-logger
ln -s $MAIN_DIR/platform-console-backend-develop/console-backend-data-logger $MAIN_DIR/console-backend-data-logger
cd $MAIN_DIR/console-backend-data-logger
npm install

cp -r $MAIN_DIR/console-backend-utils ./

# upstart script for data-logger
cp $1/components/files/data-logger.conf /etc/init/

echo 'starting data-logger service'
sudo service data-logger start

# console-backend-data-manager
cd $MAIN_DIR
ln -s $MAIN_DIR/platform-console-backend-develop/console-backend-data-manager $MAIN_DIR/console-backend-data-manager
cd $MAIN_DIR/console-backend-data-manager
npm install

cp -r $MAIN_DIR/console-backend-utils ./

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
cp $1/components/files/data-manager.conf /etc/init/

echo 'starting data-manager service'
sudo service data-manager start