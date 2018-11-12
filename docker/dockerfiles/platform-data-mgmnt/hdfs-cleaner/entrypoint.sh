#!/bin/sh
j2 /hdfs-cleaner/properties.json.tpl > /hdfs-cleaner/properties.json
cd /hdfs-cleaner
NAMENODE_HOST=${NAMENODE_HOST:-hdfs-namenode}
HBASE_HOST=${HBASE_HOST:-hbase-master}

python hdfs-cleaner.py
