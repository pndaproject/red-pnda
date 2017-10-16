#!/bin/bash
set -e
source ../utils.sh
cd $MAIN_DIR

rm -r platform-testing-develop >/dev/null 2>&1 || true
rm platform-testing-general >/dev/null 2>&1 || true

wget https://github.com/pndaproject/platform-testing/archive/develop.zip
unzip develop.zip
rm develop.zip
ln -s $MAIN_DIR/platform-testing-develop $MAIN_DIR/platform-testing-general
cd $MAIN_DIR/platform-testing-general/src/main/resources

# virtualenv
mkdir venv
virtualenv venv
source venv/bin/activate
pip install six==1.10.0
pip install -r requirements.txt
pip install -r plugins/kafka/requirements.txt
pip install -r plugins/zookeeper/requirements.txt

cp $1/components/files/platform-testing-general-kafka.conf /etc/init

cp $1/components/files/platform-testing-general-zookeeper.conf /etc/init

# a python script to return OK status for hbase and spark components. Hard coded to return OK on every run - need to change this
cp $1/components/files/hbase_spark_metric.py $MAIN_DIR

#echo new cron into cron file
echo "* * * * * sudo service platform-testing-general-zookeeper start" >> mycron
echo "* * * * * sudo service platform-testing-general-kafka start" >> mycron
echo "* * * * * /usr/bin/python $MAIN_DIR/hbase_spark_metric.py" >> mycron

#install new cron file
crontab mycron
rm mycron
