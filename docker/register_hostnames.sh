#!/bin/bash

function add_hostname () {
HOST_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $1)
if grep -q "$1$" /etc/hosts
then
  echo "Updating $1 IP in /etc/hosts"
  sudo sed -i "s/.* $1$/$HOST_IP $1/" /etc/hosts
else
  echo "creating a $1 entry in /etc/hosts"
  echo "$HOST_IP $1" |sudo tee --append "/etc/hosts"
fi
}

echo "----------------  ADDING services naming resolution through /etc/hosts  ----------------"
add_hostname console-backend
add_hostname console-frontend
add_hostname kafka-manager
add_hostname jupyter
add_hostname grafana
add_hostname opentsdb
add_hostname data-service
add_hostname package-repository
add_hostname grafana
add_hostname spark-master
add_hostname spark-worker
add_hostname flink-master
add_hostname kafka
add_hostname hbase-master
add_hostname hdfs-namenode
add_hostname hdfs-datanode

