#!/bin/bash
set -e
set -x
source ../utils.sh


echo "Installing hbase.."

wget https://archive.apache.org/dist/hbase/1.2.0/$HBASE_VERSION-bin.tar.gz
tar xzf $HBASE_VERSION-bin.tar.gz -C /usr/local/

rm $HBASE_VERSION-bin.tar.gz

cd $HBASE_HOME

# set configuration
echo "export JAVA_HOME=$JAVA_HOME" >> conf/hbase-env.sh
echo "export HBASE_MANAGES_ZK=false" >> conf/hbase-env.sh
rm conf/hbase-site.xml

# set hbase-site.xml
cp $1/components/files/hbase-site.xml $HBASE_HOME/conf/

# start hbase
echo 'starting hbase'
$HBASE_HOME/bin/start-hbase.sh

# add to PATH env variable
echo "PATH=$HBASE_HOME/bin:$PATH" >> /etc/environment
source /etc/environment