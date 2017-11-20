#!/bin/bash
set -e
set -x
source ../utils.sh


mkdir $JMXPROXY_HOME || true
cd $JMXPROXY_HOME
# jmxproxy - 3.2.0
wget https://github.com/mk23/jmxproxy/releases/download/jmxproxy.3.2.0/jmxproxy-$JMXPROXY_VERSION.jar

echo "server:
    type: simple
    applicationContextPath: /
    connector:
        type: http
        bindHost: 127.0.0.1
        port: 8000" >> jmxproxy.yaml

ln -s jmxproxy-$JMXPROXY_VERSION.jar jmxproxy.jar

# jmxproxy upstart script
cp $1/components/files/jmxproxy.conf /etc/init

echo "starting jmxproxy"
sudo service jmxproxy start