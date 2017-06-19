#/bin/bash
# simple python script
sudo pip install kafka-python
sudo pip install avro
sudo pip install pandas
sudo pip install scikit-learn

mkdir /data

cp files/dataplatform-raw.avsc /opt/pnda

cp files/consumer.py /opt/pnda

cp files/producer.py /opt/pnda

cp files/kafka-consumer.conf /etc/init

crontab -l > mycron
#echo new cron into cron file
echo "0 * * * * sudo service kafka-consumer restart" >> mycron

#install new cron file
crontab mycron
rm mycron