#/bin/bash
set -e

source ../utils.sh

# simple python script
sudo pip install kafka-python
sudo pip install avro
sudo pip install pandas
sudo pip install scipy
sudo pip install scikit-learn

if [ ! -d /data ]; then
	mkdir /data
fi

cp $1/components/files/dataplatform-raw.avsc /opt/pnda

cp $1/components/files/consumer.py /opt/pnda

sed -i "s/localhost/$2/g" /opt/pnda/consumer.py

cp $1/components/files/producer.py /opt/pnda

sed -i "s/localhost/$2/g" /opt/pnda/producer.py

cp $1/components/files/kafka-consumer.conf /etc/init

crontab -l > mycron
#echo new cron into cron file
echo "0 * * * * sudo service kafka-consumer restart" >> mycron

#install new cron file
crontab mycron
rm mycron
