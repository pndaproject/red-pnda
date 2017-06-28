#!/bin/bash
mkdir /opt/pnda/jmxproxy
cd /opt/pnda/jmxproxy
# jmxproxy - 3.2.0
wget https://github.com/mk23/jmxproxy/releases/download/jmxproxy.3.2.0/jmxproxy-3.2.0.jar

echo "server:
    type: simple
    applicationContextPath: /
    connector:
        type: http
        bindHost: 127.0.0.1
        port: 8000" >> jmxproxy.yaml

ln -s jmxproxy-3.2.0.jar jmxproxy.jar

# jmxproxy upstart script
cp $1/scripts/files/jmxproxy.conf  /etc/init

sudo service jmxproxy start