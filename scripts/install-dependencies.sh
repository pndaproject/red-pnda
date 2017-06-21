#!/bin/bash

pwd=$(pwd)
# export eth0 address for other scripts. This is assuming eth1 is the interface which is reachable from host network
ip=$(/sbin/ip -o -4 addr list $1 | awk '{print $4}' | cut -d/ -f1)
export ip=ip

sudo apt-get update

# base working dir
sudo mkdir /opt/pnda

# install nginx
sudo apt-get install -y nginx

# install python-pip & other dependencies
sudo apt-get install -y python-pip python-dev build-essential libffi-dev libssl-dev libxml2-dev libxslt1-dev libjpeg8-dev zlib1g-dev libsasl2-dev gnuplot git

# install nodejs
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install -y nodejs

# install java8
sudo apt-get install -y python-software-properties debconf-utils
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
sudo apt-get install -y oracle-java8-installer

# virtualbox guest additions
# sudo mount /dev/cdrom /media/cdrom
# sudo apt-get install -y dkms build-essential linux-headers-generic linux-headers-$(uname -r)
# sudo /media/cdrom/VBoxLinuxAdditions.run

# install redis-server
sudo apt-get install -y redis-server
# install unzip
sudo apt-get install -y unzip

# zookeeper
sudo apt-get install -y zookeeperd

# install scala 2.11.7
wget http://www.scala-lang.org/files/archive/scala-2.11.7.tgz
sudo mkdir /usr/local/src/scala
sudo tar xvf scala-2.11.7.tgz -C /usr/local/src/scala/

# add to PATH env variable
echo "export PATH=/usr/local/src/scala/scala-2.11.7/bin:$PATH" >> /etc/profile

source /etc/profile

# install spark 1.6.1 standalone
wget https://d3kbcqa49mib13.cloudfront.net/spark-1.6.1-bin-hadoop2.6.tgz
tar xzf spark-1.6.1-bin-hadoop2.6.tgz -C /usr/local/

# add to PATH env variable
echo "export PATH=/usr/local/spark-1.6.1-bin-hadoop2.6/bin:$PATH" >> /etc/profile

source /etc/profile

sudo pip install virtualenv

# install console-backend-utils
bash ./console-backend.sh $pwd

# install console-frontend
bash ./console-frontend.sh $pwd

# install jupyter
bash ./jupyter.sh $pwd

# install hbase
bash ./hbase.sh $pwd

# install kafka
bash ./kafka.sh $pwd

# install jmxproxy
bash ./jmxproxy.sh $pwd

# install platform testing general
bash ./platform-testing.sh $pwd

# install opentsdb
bash ./opentsdb.sh $pwd

# install grafana
bash ./grafana-server.sh $pwd

# install kafka-manager
bash ./kafka-manager.sh $pwd

# start opentsdb after a delay of 15 seconds and start kafka-manager
cp $pwd/files/opentsdb-kafka-manager-boot.sh /opt/pnda

# install crontab
crontab -l > mycron
#echo new cron into cron file
echo "@reboot sleep 15 && /usr/local/hbase-1.2.0/bin/start-hbase.sh" >> mycron
echo "@reboot bash /opt/pnda/opentsdb-kafka-manager-boot.sh" >> mycron
# start spark master & slave worker on reboot
host_name=$(hostname)
echo "@reboot /usr/local/spark-1.6.1-bin-hadoop2.6/sbin/start-master.sh && /usr/local/spark-1.6.1-bin-hadoop2.6/sbin/start-slave.sh spark://$host_name:7077" >> mycron

#install new cron file
crontab mycron
rm mycron

bash ./kafka-consumer.sh

# install useful libs
sudo pip install pandas
sudo pip install matplotlib
sudo pip install scikit-learn

bash ./platform-libraries.sh

cp $pwd/files/zk-opentsdb-restart.sh /opt/pnda

cp $pwd/assign-ip.sh /opt/pnda

sudo bash /opt/pnda/assign-ip.sh $1