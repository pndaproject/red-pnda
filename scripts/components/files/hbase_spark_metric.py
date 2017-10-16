import requests
import json
import time

TIMESTAMP_MILLIS = lambda: int(time.time() * 1000)

components = {'hbase01': 'hadoop.HBASE.health', 'spark_on_yarn': 'hadoop.SPARK_ON_YARN.health'}
host = "http://127.0.0.1:3001/metrics"

for key, value in components.iteritems():
    json_data = {"data": [{"source": key, "metric": value, "value": "OK", "causes": "[]", "timestamp": TIMESTAMP_MILLIS()}], "timestamp": TIMESTAMP_MILLIS()}
    try:
        headers = {'Content-Type': 'application/json', 'Connection':'close'}
        response = requests.post(host, data=json.dumps(json_data), headers=headers)
        if response.status_code != 200:
            print "_send failed: %s", response.status_code
    except requests.exceptions.RequestException as ex:
        print "_send failed: %s", ex