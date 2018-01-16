#!/bin/bash
set -e
set -x

source ../utils.sh


echo "installing kafka.."
wget http://archive.apache.org/dist/kafka/0.11.0.0/$KAFKA_VERSION.tgz
tar xzf $KAFKA_VERSION.tgz -C /usr/local/

# remove kafka tar file
rm $KAFKA_VERSION.tgz

cd $KAFKA_HOME

echo -en '\n' >> config/server.properties
echo "listener.security.protocol.map=INGEST:PLAINTEXT,REPLICATION:PLAINTEXT,INTERNAL_PLAINTEXT:PLAINTEXT" >> config/server.properties
echo "listeners=INGEST://$2:9094,REPLICATION://127.0.0.1:9093,INTERNAL_PLAINTEXT://$2:9092" >> config/server.properties
echo "advertised.listeners=INGEST://$2:9094,REPLICATION://127.0.0.1:9093,INTERNAL_PLAINTEXT://$2:9092" >> config/server.properties
echo "inter.broker.listener.name=REPLICATION" >> config/server.properties

# start kafka server

cp $1/components/files/kafka.conf /etc/init/

# start kafka
echo "starting kafka"
sudo service kafka start

