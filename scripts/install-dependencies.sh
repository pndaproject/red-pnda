#!/bin/bash
set -e
set -x

source utils.sh

if [ $# -eq 0 ]
  then
    echo "No arguments supplied. Please supply your reachable network interface e.g. eth0 or eth1"
    exit 1
fi

pwd=$(pwd)

if [[ "$pwd" == *scripts ]]
then
    # do nothing
	echo 
else
    pwd+="/scripts"
fi

echo "present working dir : $pwd" 

echo "HBASE_HOME=/usr/local/$HBASE_VERSION" >> /etc/environment
echo "KAFKA_HOME=/usr/local/$KAFKA_VERSION" >> /etc/environment
echo "SCALA_HOME=/usr/local/src/scala" >> /etc/environment
echo "SPARK_HOME=/usr/local/spark" >> /etc/environment
echo "JAVA_HOME=/usr/lib/jvm/java-8-oracle" >> /etc/environment
echo "JMXPROXY_HOME=$MAIN_DIR/jmxproxy" >> /etc/environment

source /etc/environment


# get IP address
ip=$(/sbin/ip -o -4 addr list $1 | awk '{print $4}' | cut -d/ -f1)

sudo apt-get update

# base working dir
sudo mkdir /opt/pnda || true

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


if [ ! -d $SCALA_HOME ]; then

	# install scala
	wget http://www.scala-lang.org/files/archive/$SCALA_VERSION.tgz
	sudo tar xvf $SCALA_VERSION.tgz -C /usr/local/
	mv /usr/local/$SCALA_VERSION $SCALA_HOME
	# remove scala tar file
	rm $SCALA_VERSION.tgz
fi

# add to PATH env variable
echo "PATH=$SCALA_HOME/bin:$PATH" >> /etc/environment

source /etc/environment

if [ ! -d $SPARK_HOME ]; then

	# install spark 1.6.1 standalone
	wget https://d3kbcqa49mib13.cloudfront.net/$SPARK_VERSION.tgz
	tar xzf $SPARK_VERSION.tgz -C /usr/local/
	mv /usr/local/$SPARK_VERSION $SPARK_HOME
	# remove spark tar file
	rm $SPARK_VERSION.tgz
fi

# add to PATH env variable
echo "PATH=$SPARK_HOME/bin:$PATH" >> /etc/environment

source /etc/environment

sudo pip install virtualenv

set +e

# if proxy env variable is set, change the npm config
if [[ ! (-z "${http_proxy}") || ! (-z "${HTTP_PROXY}") ]]; then
	npm config set strict-ssl false
	npm config set registry http://registry.npmjs.org/
else
	echo "No proxy required for npm"
fi

set -e

cd $pwd/components

# install console-backend-utils
bash console-backend.sh $pwd

# install console-frontend
bash console-frontend.sh $pwd

# install jupyter
bash jupyter.sh $pwd

# install hbase
bash hbase.sh $pwd

# install kafka
bash kafka.sh $pwd $ip

# install jmxproxy
bash jmxproxy.sh $pwd

# install platform testing general
bash platform-testing.sh $pwd

# install opentsdb
bash opentsdb.sh $pwd

# install grafana
bash grafana-server.sh $pwd $ip

# install kafka-manager
bash kafka-manager.sh $pwd

# start opentsdb after a delay of 15 seconds and start kafka-manager
cp files/opentsdb-kafka-manager-boot.sh /opt/pnda

# install crontab
crontab -l > mycron
#echo new cron into cron file
echo "@reboot sleep 10 && $HBASE_HOME/bin/start-hbase.sh" >> mycron
echo "@reboot bash /opt/pnda/opentsdb-kafka-manager-boot.sh" >> mycron
# start spark master & slave worker on reboot
host_name=$(hostname)
echo "@reboot $SPARK_HOME/sbin/start-master.sh && $SPARK_HOME/sbin/start-slave.sh spark://$host_name:7077" >> mycron

#install new cron file
crontab mycron
rm mycron

bash kafka-consumer.sh $pwd $ip

# install useful python libraries
sudo pip install pandas
sudo pip install matplotlib
sudo pip install scikit-learn

bash platform-libraries.sh $pwd

cp files/zk-opentsdb-restart.sh /opt/pnda

cp assign-ip.sh /opt/pnda

sudo bash /opt/pnda/assign-ip.sh $1

echo "#####################################################"
echo
echo
echo "Your Red-PNDA is successfully installed. Please reboot your machine and go to http://$ip on your browser to view the PNDA console!"

