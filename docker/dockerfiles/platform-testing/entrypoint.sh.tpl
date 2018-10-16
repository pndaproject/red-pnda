#/bin/sh

while true
do
python /platform-testing-general/monitor.py --plugin zookeeper \
--postjson http://{{ CONSOLE_HOSTS | default('console-backend-data-logger:3001') }}/metrics \
--extra "--zconnect {{ ZOOKEEPERS | default('zookeeper:2181') }}"

python /platform-testing-general/monitor.py --plugin kafka \
--postjson http://{{ CONSOLE_HOSTS | default('console-backend-data-logger:3001') }}/metrics \
--extra "--brokerlist {{ KAFKA_BROKERS | default('kafka:9092') }} \
--zkconnect {{ ZOOKEEPERS | default('zookeeper:2181') }} --prod2cons"

python /hbase_spark_metric.py http://{{ CONSOLE_HOSTS | default('console-backend-data-logger:3001') }}/metrics
sleep 60
done
