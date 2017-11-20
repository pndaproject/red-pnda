#!/bin/bash
set -e
set -x
source ../utils.sh
cd $MAIN_DIR

echo 'installing grafana..'
wget https://s3-us-west-2.amazonaws.com/grafana-releases/release/$GRAFANA_VERSION.deb
sudo apt-get install -y adduser libfontconfig
sudo dpkg -i $GRAFANA_VERSION.deb

sudo service grafana-server start

sleep 10

# Exit if the pnda user already exists
curl --fail -s -H "Content-Type: application/json" -X GET http://pnda:pndapnda@localhost:3000/api/users || true

# Rename the admin user to the pnda user
curl -s -H "Content-Type: application/json" -X PUT -d '{"name":"pnda", "email":"pnda@pnda.com", "login":"pnda", "password":"pndapnda"}' http://admin:admin@localhost:3000/api/users/1 || true

# Change the password
curl -s -H "Content-Type: application/json" -X PUT -d '{"oldPassword": "admin", "newPassword":"pndapnda", "confirmNew":"pndapnda"}' http://pnda:admin@localhost:3000/api/user/password || true

cp $1/components/files/create_or_update_ds.py $MAIN_DIR/

python ./create_or_update_ds.py pnda pndapnda http://localhost:3000 '{ "name": "PNDA OpenTSDB", "type": "opentsdb", "url": "http://'$2':4242", "access": "direct", "basicAuth": false, "isDefault": true }'

echo 'starting grafana..'
sudo service grafana-server stop && sudo service grafana-server start

# start grafana-serve ron boot
sudo update-rc.d grafana-server defaults