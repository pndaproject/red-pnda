#!/bin/bash

echo "----------------  STARTING HDFS and HBASE   ----------------"
docker-compose up -d zookeeper
docker-compose up -d hdfs-namenode
docker-compose up -d hdfs-datanode
docker-compose up -d hbase-master
while ! docker exec -ti hdfs-namenode nc -vz hdfs-namenode:8020 ; do
  echo "waiting for hdfs-namenode to start"
  sleep 2
done
docker-compose up -d hbase-region

echo "----------------  ADDING users to HDFS  ----------------"
echo "adding hdfs as admin superuser"
docker exec -ti hdfs-namenode adduser --system --gecos "" --ingroup=root --shell /bin/bash --disabled-password hdfs
echo "adding pnda user"
PNDA_USER=pnda
PNDA_GROUP=pnda
docker exec -ti hdfs-namenode addgroup $PNDA_GROUP
docker exec -ti hdfs-namenode adduser --gecos "" --ingroup=$PNDA_GROUP --shell /bin/bash --disabled-password $PNDA_USER
docker exec -ti hdfs-namenode hdfs dfs -mkdir -p /user/$PNDA_USER
docker exec -ti hdfs-namenode hdfs dfs -chown $PNDA_USER:$PNDA_GROUP /user/$PNDA_USER
docker exec -ti hdfs-namenode hdfs dfs -chmod 770 /user/$PNDA_USER


echo "----------------  ADDING KITE_TOOLS to HDFS NAMENODE AND INITIALIZE PNDA REPOs  ----------------"
docker cp hdfs/kite-files/pnda.avsc hdfs-namenode:/tmp/pnda.avsc
docker cp hdfs/kite-files/pnda_kite_partition.json hdfs-namenode:/tmp/pnda_kite_partition.json
docker exec -i hdfs-namenode apk add --no-cache curl
docker exec -i hdfs-namenode /bin/bash < hdfs/add_kite_tools_and_create_db.sh

echo "----------------  CREATING HBASE TABLES for OPENTSDB  ----------------"
docker exec -i hbase-master /bin/bash < opentsdb/create_opentsdb_hbase_tables.sh

echo "----------------  ENABLING THRIFT API in HBASE MASTER  ----------------"
docker exec -d hbase-master hbase thrift start -p 9090
while ! docker exec -ti hbase-master nc -vz hbase-master:9090 ; do
  echo "waiting for hbase thrift api to start"
  sleep 2
done
echo "----------------  STARTING THE REST OF THE SERVICES   ----------------"
docker-compose up -d
echo "----------------  CREATING pnda user in services  ----------------"
docker exec deployment-manager sh -c 'adduser -D pnda && echo "pnda:pnda" | chpasswd'
docker exec jupyter-ssh sh -c 'adduser -D pnda && echo "pnda:pnda" | chpasswd'

echo "----------------  ADDING ssh keys to dm_keys volume   ----------------"
mkdir -p dm_keys
echo "Generating SSH Keys for Deployment Manager connections"
        ssh-keygen -b 2048 -t rsa -f dm_keys/dm -q -N ""
cp dm_keys/dm dm_keys/dm.pem

docker cp dm_keys/ deployment-manager:/opt/pnda/
docker exec -ti deployment-manager chown -R root:root /opt/pnda/dm_keys/
docker exec -ti deployment-manager chmod 644 /opt/pnda/dm_keys/dm.pub
docker exec -ti deployment-manager chmod 600 /opt/pnda/dm_keys/dm.pem
docker exec -ti deployment-manager chmod 600 /opt/pnda/dm_keys/dm


echo "----------------  ADDING Public key to jupyter-ssh  ----------------"
docker exec jupyter-ssh mkdir -p /home/pnda/.ssh
docker cp dm_keys/dm.pub jupyter-ssh:/home/pnda/.ssh/authorized_keys
docker exec jupyter-ssh chmod 644 /home/pnda/.ssh/authorized_keys
docker exec jupyter-ssh chown -R pnda:pnda /home/pnda/.ssh
docker exec jupyter-ssh mkdir -p /root/.ssh
docker cp dm_keys/dm.pub jupyter-ssh:/root/.ssh/authorized_keys
docker exec jupyter-ssh chmod 644 /root/.ssh/authorized_keys
docker exec jupyter-ssh chown -R root:root /root/.ssh
echo "----------------  ADDING Public key to deployment-manager-ssh  ----------------"
#docker exec deployment-manager-ssh mkdir -p /root/.ssh
#docker cp dm_keys/dm.pub deployment-manager-ssh:/root/.ssh/authorized_keys
#docker exec deployment-manager-ssh chmod 644 /root/.ssh/authorized_keys
#docker exec deployment-manager-ssh chown -R root:root /root/.ssh

./register_hostnames.sh

#echo "----------------  OOZIE create sharelib in HDFS  ----------------"
#docker exec oozie oozie-setup.sh sharelib create -fs hdfs://hdfs-namenode:8020
echo "----------------  KAFKA-MANAGER CONFIGURATION  ----------------"
curl -X POST \
  http://kafka-manager:10900/clusters \
  -H 'content-type: application/x-www-form-urlencoded' \
  -d 'name=PNDA&zkHosts=zookeeper%3A2181&kafkaVersion=1.0.0&jmxEnabled=true&jmxUser=&jmxPass=&activeOffsetCacheEnabled=true&securityProtocol=PLAINTEXT' &>/dev/null

echo "----------------  GRAFANA: importing data sources and dashboards  ----------------"
timeout 10s bash -c 'while [[ $(curl -s -o /dev/null -w %{http_code} http://grafana:3000/login) != 200 ]]; do sleep 1; done; echo OK' || echo TIMEOUT

curl -H "Content-Type: application/json" -X POST \
-d '{"name":"PNDA OpenTSDB","type":"opentsdb","url":"http://localhost:4242","access":"proxy","basicAuth": false,"isDefault": true }' \
http://pnda:pnda@grafana:3000/api/datasources
curl -H "Content-Type: application/json" -X POST \
-d '{"name":"PNDA Graphite","type":"graphite","url":"http://$GRAPHITE_HOST:$GRAPHITE_PORT","access":"proxy","basicAuth":false,"isDefault":false}' \
http://pnda:pnda@grafana:3000/api/datasources
./grafana/grafana-import-dashboards.sh grafana/PNDA.json
./grafana/grafana-import-dashboards.sh grafana/PNDA-DM.json
./grafana/grafana-import-dashboards.sh grafana/PNDA-Hadoop.json
./grafana/grafana-import-dashboards.sh grafana/PNDA-Kafka.json
echo "red-PNDA Deployment Finished - Opening console-frontend web ui"
xdg-open http://console-frontend






