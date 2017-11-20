#!/bin/bash
set -e
set -x

source ../utils.sh


echo "installing kafka.."
wget http://archive.apache.org/dist/kafka/0.10.2.1/$KAFKA_VERSION.tgz
tar xzf $KAFKA_VERSION.tgz -C /usr/local/

# remove kafka tar file
rm $KAFKA_VERSION.tgz

cd $KAFKA_HOME

echo "listeners=PLAINTEXT://$2:9092" >> config/server.properties

echo "advertised.listeners=PLAINTEXT://$2:9092" >> config/server.properties

# start kafka server

cp $1/components/files/kafka.conf /etc/init/

# start kafka
echo "starting kafka"
sudo service kafka start

