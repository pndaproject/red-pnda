#!/bin/bash
sleep 15 && sudo service hbase restart && sudo service opentsdb restart
sudo service kafka-manager stop
sudo rm /opt/pnda/kafka-manager-1.3.3.6/kafka-manager-1.3.3.6/RUNNING_PID
sudo service kafka-manager start