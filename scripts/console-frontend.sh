#!/bin/bash

# console-frontend
cd /opt/pnda
wget https://github.com/pndaproject/platform-console-frontend/archive/develop.zip
unzip develop.zip
rm develop.zip
ln -s /opt/pnda/platform-console-frontend-develop/console-frontend /opt/pnda/console-frontend
cd /opt/pnda/platform-console-frontend-develop/

npm install -g grunt-cli

bash build.sh

tar xzf pnda-build/*.tar.gz

rm -r /opt/pnda/platform-console-frontend-develop/console-frontend

mv pnda-build/console-frontend- pnda-build/console-frontend
mv pnda-build/console-frontend /opt/pnda/platform-console-frontend-develop

rm conf/PNDA.json
# add PNDA.json conf
cat <<EOF >  conf/PNDA.json
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
cp $1/files/nginx-PNDA.conf  /etc/nginx/sites-enabled/PNDA.conf

# remove default nginx config
rm /etc/nginx/sites-enabled/default
# restart nginx service
sudo service nginx restart