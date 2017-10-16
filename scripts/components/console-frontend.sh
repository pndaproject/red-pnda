#!/bin/bash
set -e
source ../utils.sh

# console-frontend
cd $MAIN_DIR

# if directory present, delete it
rm -r platform-console-frontend-develop >/dev/null 2>&1 || true
rm console-frontend >/dev/null 2>&1 || true
rm /etc/nginx/sites-enabled/PNDA.conf >/dev/null 2>&1 || true

wget https://github.com/pndaproject/platform-console-frontend/archive/develop.zip
unzip develop.zip
rm develop.zip
ln -s $MAIN_DIR/platform-console-frontend-develop/console-frontend $MAIN_DIR/console-frontend
cd $MAIN_DIR/platform-console-frontend-develop/

# install grunt-cli
npm install -g grunt-cli

bash build.sh

tar xzf pnda-build/*.tar.gz

rm -r $MAIN_DIR/platform-console-frontend-develop/console-frontend

mv console-frontend- console-frontend

# add PNDA.json conf
cat <<EOF >  console-frontend/conf/PNDA.json
{
  "clustername": "Red PNDA",
  "edge_node": "$ip",
  "user_interfaces": [
    {
      "name": "Kafka Manager",
      "link": "http://$ip:10900"
    },
    {
      "name": "OpenTSDB",
      "link": "http://$ip:4242"
    },
    {
      "name": "Grafana",
      "link": "http://$ip:3000"
    },
    {
      "name": "Spark Web UI",
      "link": "http://$ip:8080"
    },
    {
      "name": "Jupyter",
      "link": "http://$ip:9000"
    }
  ],
  "frontend": {
    "version": "1.0.0"
  },
  "backend": {
    "data-manager": {
      "version": "1.0.0",
      "host": "$ip", "port": "3123"
    }
  },
  "disable_ldap_login": true
}
EOF

# add PNDA nginx conf to /etc/nginx/sites-enabled
cp $1/components/files/nginx-PNDA.conf  /etc/nginx/sites-enabled/PNDA.conf

# remove default nginx config
rm /etc/nginx/sites-enabled/default >/dev/null 2>&1 || true

echo 'starting nginx..'
# restart nginx service
sudo service nginx restart