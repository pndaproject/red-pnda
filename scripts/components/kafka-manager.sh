#!/bin/bash
set -e
set -x
source ../utils.sh
# kafka-manager
cd $MAIN_DIR

rm -r $KAFKA_MANAGER_VERSION >/dev/null 2>&1 || true

echo 'installing kafka-manager..'

wget https://github.com/yahoo/kafka-manager/archive/1.3.3.6.tar.gz
tar xzf 1.3.3.6.tar.gz

# remove the archive
rm 1.3.3.6.tar.gz
cd $KAFKA_MANAGER_VERSION
sed -i 's/kafka-manager-zookeeper/127.0.0.1/' conf/application.conf
./sbt clean dist
unzip target/universal/$KAFKA_MANAGER_VERSION.zip

# kafka-manager upstart
cp $1/components/files/kafka-manager.conf /etc/init/

echo 'starting kafka-manager..'
# start kafka-manager and wait for 10 seconds
sudo service kafka-manager start && sleep 10