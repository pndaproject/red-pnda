#!/bin/bash
cd /opt/pnda
wget https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana_4.3.1_amd64.deb
sudo apt-get install -y adduser libfontconfig
sudo dpkg -i grafana_4.3.1_amd64.deb

sudo service grafana-server start

# Exit if the pnda user already exists
curl --fail -s -H "Content-Type: application/json" -X GET http://pnda:pndapnda@localhost:3000/api/users && echo "pnda user already exists" && exit 0

# Rename the admin user to the pnda user
curl -s -H "Content-Type: application/json" -X PUT -d '{"name":"pnda", "email":"pnda@pnda.com", "login":"pnda", "password":"pndapnda"}' http://admin:admin@localhost:3000/api/users/1

# Change the password
curl -s -H "Content-Type: application/json" -X PUT -d '{"oldPassword": "admin", "newPassword":"pndapnda", "confirmNew":"pndapnda"}' http://pnda:admin@localhost:3000/api/user/password

cp files/create_or_update_ds.py /opt/pnda/

python ./create_or_update_ds.py pnda pndapnda http://localhost:3000 '{ "name": "PNDA OpenTSDB", "type": "opentsdb", "url": "http://localhost:4242", "access": "direct", "basicAuth": false, "isDefault": true }'

sudo service grafana-server restart

# start grafana-serve ron boot
sudo update-rc.d grafana-server defaults