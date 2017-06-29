#/bin/bash
# simple python script
if [[ $2 -eq 1 ]]; then
	sudo pip --proxy ${http_proxy} install kafka-python avro scipy
else
	sudo pip install kafka-python avro scipy
fi

if [ ! -d /data ]; then
	mkdir /data
fi

cp $1/scripts/files/dataplatform-raw.avsc /opt/pnda

cp $1/scripts/files/consumer.py /opt/pnda

cp $1/scripts/files/producer.py /opt/pnda

cp $1/scripts/files/kafka-consumer.conf /etc/init

crontab -l > mycron
#echo new cron into cron file
echo "0 * * * * sudo service kafka-consumer restart" >> mycron

#install new cron file
crontab mycron
rm mycron