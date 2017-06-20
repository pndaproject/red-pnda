#!/bin/bash
cd /opt/pnda
wget https://github.com/pndaproject/platform-testing/archive/develop.zip
unzip develop.zip
rm develop.zip
ln -s /opt/pnda/platform-testing-develop /opt/pnda/platform-testing-general
cd /opt/pnda/platform-testing-general/src/main/resources

# virtualenv
mkdir venv
virtualenv venv
source venv/bin/activate
pip install six==1.10.0
pip install -r requirements.txt
pip install -r plugins/kafka/requirements.txt
pip install -r plugins/zookeeper/requirements.txt

cp $1/files/platform-testing-general-kafka.conf /etc/init

cp $1/files/platform-testing-general-zookeeper.conf /etc/init

# a python script to return OK status for hbase and spark components. Hard coded to return OK on every run - need to change this
cp $1/files/hbase_spark_metric.py /opt/pnda

# install crontab
crontab -l > mycron
#echo new cron into cron file
echo "* * * * * sudo service platform-testing-general-zookeeper start" >> mycron
echo "* * * * * sudo service platform-testing-general-kafka start" >> mycron
echo "* * * * * /usr/bin/python /opt/pnda/hbase_spark_metric.py" >> mycron

#install new cron file
crontab mycron
rm mycron
