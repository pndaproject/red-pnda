#!/bin/bash

KAFKA_HOME=/usr/local/kafka_2.11-0.10.2.0

# if directory does not exist
if [ ! -d "$KAFKA_HOME" ]; then
	# kafka 0.10.2.0
	wget http://mirrors.gigenet.com/apache/kafka/0.10.2.0/kafka_2.11-0.10.2.0.tgz
	tar xzf kafka_2.11-0.10.2.0.tgz -C /usr/local/

	# remove kafka tar
	rm kafka_2.11-0.10.2.0.tgz

	cd /usr/local/kafka_2.11-0.10.2.0

	echo "listeners=PLAINTEXT://$2:9092" >> config/server.properties

	echo "advertised.listeners=PLAINTEXT://$2:9092" >> config/server.properties

	# start kafka server

	cp $1/scripts/files/kafka.conf /etc/init/

	# start kafka
	sudo service kafka start
else
	echo "Kafka already installed. Moving on!"
fi
