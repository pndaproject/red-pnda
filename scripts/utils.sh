#!/bin/bash

HBASE_VERSION=hbase-1.2.0
OPENTSDB_VERSION=opentsdb-2.2.0_all
KAFKA_VERSION=kafka_2.11-0.10.2.0
GRAFANA_VERSION=grafana_4.3.1_amd64
JMXPROXY_VERSION=3.2.0
SCALA_VERSION=scala-2.11.7
SPARK_VERSION=spark-1.6.1-bin-hadoop2.6
KAFKA_MANAGER_VERSION=kafka-manager-1.3.3.6

export HBASE_HOME=/usr/local/$HBASE_VERSION
export KAFKA_HOME=/usr/local/$KAFKA_VERSION
export SCALA_HOME=/usr/local/src/scala
export SPARK_HOME=/usr/local/spark
export JAVA_HOME=/usr/lib/jvm/java-8-oracle
export MAIN_DIR=/opt/pnda
export JMXPROXY_HOME=$MAIN_DIR/jmxproxy