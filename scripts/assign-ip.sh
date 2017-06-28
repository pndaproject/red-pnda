#/bin/bash

if [ $# -eq 0 ]
  then
    echo "No arguments supplied. Please supply your reachable network interface e.g. eth0 or eth1"
    exit 1
fi

ip=$(/sbin/ip -o -4 addr list $1 | awk '{print $4}' | cut -d/ -f1)

rm /opt/pnda/console-frontend/conf/PNDA.json >/dev/null 2>&1
rm /etc/init/data-manager.conf >/dev/null 2>&1

cat <<EOF > /opt/pnda/console-frontend/conf/PNDA.json
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

cat <<EOF > /etc/init/data-manager.conf
start on runlevel [2345]
stop on runlevel [016]

normal exit 0
respawn
respawn limit unlimited
post-stop exec sleep 2

env HOSTNAME=$ip
env PORT=3123
exec node /opt/pnda/console-backend-data-manager/app.js
EOF


sudo service data-manager restart && sudo service nginx restart 
sudo service zookeeper restart >/dev/null 2>&1
sudo service opentsdb restart >/dev/null 2>&1