#!/bin/bash
cd /opt/pnda

# if opentsdb does not exist
if [[ ! $(dpkg -l | grep opentsdb)  ]]; then
    
	# opentsdb 2.2.0
	wget https://github.com/OpenTSDB/opentsdb/releases/download/v2.2.0/opentsdb-2.2.0_all.deb
	sudo dpkg -i opentsdb-2.2.0_all.deb

	# remove deb file
	rm opentsdb-2.2.0_all.deb
	# create hbase tables
	echo "create 'tsdb', 'cf'" | /usr/local/hbase-1.2.0/bin/hbase shell
	echo "create 'tsdb-uid', 'cf'" | /usr/local/hbase-1.2.0/bin/hbase shell
	echo "create 'tsdb-tree', 'cf'" | /usr/local/hbase-1.2.0/bin/hbase shell
	echo "create 'tsdb-meta', 'cf'" | /usr/local/hbase-1.2.0/bin/hbase shell

	echo "JAVA_HOME=/usr/lib/jvm/java-8-oracle" >> /etc/default/opentsdb

	# start opentsdb on boot
	sudo update-rc.d opentsdb defaults 99

	sudo service opentsdb restart
else
	echo "OpenTSDB already installed. Moving on!"
fi

