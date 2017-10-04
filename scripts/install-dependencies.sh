#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "No arguments supplied. Please supply your reachable network interface e.g. eth0 or eth1"
    exit 1
fi

pwd=$(pwd)
# get IP address
ip=$(/sbin/ip -o -4 addr list $1 | awk '{print $4}' | cut -d/ -f1)

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


if [ ! -d /usr/local/scala ]; then

	# install scala 2.11.7
	wget http://www.scala-lang.org/files/archive/scala-2.11.7.tgz
	sudo mkdir /usr/local/src/scala
	sudo tar xvf scala-2.11.7.tgz -C /usr/local/src/scala/

	# remove scala tar file
	rm scala-2.11.7.tgz
fi

# add to PATH env variable
echo "export PATH=/usr/local/src/scala/scala-2.11.7/bin:$PATH" >> /etc/profile

source /etc/profile

if [ ! -d /usr/local/spark-1.6.1-bin-hadoop2.6 ]; then

	# install spark 1.6.1 standalone
	wget https://d3kbcqa49mib13.cloudfront.net/spark-1.6.1-bin-hadoop2.6.tgz
	tar xzf spark-1.6.1-bin-hadoop2.6.tgz -C /usr/local/

	# remove spark tar file
	rm spark-1.6.1-bin-hadoop2.6.tgz
fi

# add to PATH env variable
echo "export PATH=/usr/local/spark-1.6.1-bin-hadoop2.6/bin:$PATH" >> /etc/profile

source /etc/profile

sudo pip install virtualenv

# if proxy env variable is set, change the npm config
if [[ ! (-z "${http_proxy}") || ! (-z "${HTTP_PROXY}") ]]; then
	npm config set strict-ssl false
	npm config set registry http://registry.npmjs.org/
else
	echo "No proxy required for npm"
fi

# install console-backend-utils
bash $pwd/scripts/console-backend.sh $pwd

# install console-frontend
bash $pwd/scripts/console-frontend.sh $pwd

# install jupyter
bash $pwd/scripts/jupyter.sh $pwd

# install hbase
bash $pwd/scripts/hbase.sh $pwd

# install kafka
bash $pwd/scripts/kafka.sh $pwd $ip

# install jmxproxy
bash $pwd/scripts/jmxproxy.sh $pwd

# install platform testing general
bash $pwd/scripts/platform-testing.sh $pwd

# install opentsdb
bash $pwd/scripts/opentsdb.sh $pwd

# install grafana
bash $pwd/scripts/grafana-server.sh $pwd

# install kafka-manager
bash $pwd/scripts/kafka-manager.sh $pwd

# start opentsdb after a delay of 15 seconds and start kafka-manager
cp $pwd/scripts/files/opentsdb-kafka-manager-boot.sh /opt/pnda

# install crontab
crontab -l > mycron
#echo new cron into cron file
echo "@reboot sleep 10 && /usr/local/hbase-1.2.0/bin/start-hbase.sh" >> mycron
echo "@reboot bash /opt/pnda/opentsdb-kafka-manager-boot.sh" >> mycron
# start spark master & slave worker on reboot
host_name=$(hostname)
echo "@reboot /usr/local/spark-1.6.1-bin-hadoop2.6/sbin/start-master.sh && /usr/local/spark-1.6.1-bin-hadoop2.6/sbin/start-slave.sh spark://$host_name:7077" >> mycron

#install new cron file
crontab mycron
rm mycron

bash $pwd/scripts/kafka-consumer.sh $pwd $ip

# install useful libs
sudo pip install pandas
sudo pip install matplotlib
sudo pip install scikit-learn

bash $pwd/scripts/platform-libraries.sh

cp $pwd/scripts/files/zk-opentsdb-restart.sh /opt/pnda

cp $pwd/scripts/assign-ip.sh /opt/pnda

sudo bash /opt/pnda/assign-ip.sh $1

echo "#####################################################"
echo
echo
echo "Your Red-PNDA is successfully installed. Go to http://$ip on your browser to view the console!"

