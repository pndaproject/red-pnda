#!/bin/bash
set -e
set -x
source ../utils.sh

cd $MAIN_DIR

echo "installing opentsdb"
wget https://github.com/OpenTSDB/opentsdb/releases/download/v2.2.0/$OPENTSDB_VERSION.deb
sudo dpkg -i $OPENTSDB_VERSION.deb

# remove deb file
rm $OPENTSDB_VERSION.deb
# create hbase tables
cp $1/components/files/create-tables.sh ./
echo "creating tables in hbase.."
bash create-tables.sh 

echo "JAVA_HOME=$JAVA_HOME" >> /etc/default/opentsdb
echo "tsd.network.bind = 0.0.0.0" >> /etc/opentsdb/opentsdb.conf
echo "tsd.core.auto_create_metrics = true" >> /etc/opentsdb/opentsdb.conf
echo "tsd.http.request.cors_domains = *" >> /etc/opentsdb/opentsdb.conf
echo "tsd.http.request.cors_headers = Authorization, Content-Type, Accept, Origin, User-Agent, DNT, Cache-Control, X-Mx-ReqToken, Keep-Alive, X-Requested-With, If-Modified-Since" >> /etc/opentsdb/opentsdb.conf

# start opentsdb on boot
sudo update-rc.d opentsdb defaults 99

echo "starting opentsdb service"
sudo service opentsdb stop && sudo service opentsdb start
