# pylint: disable=line-too-long
"""
Name:       Sample python code for Kafka Client
Purpose:    Producing messages to Kafka topics

Author:     PNDA team

Created:    14/12/2015

Copyright (c) 2016 Cisco and/or its affiliates.

This software is licensed to you under the terms of the Apache License, Version 2.0 (the "License").
You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

The code, technical concepts, and all information contained herein, are the property of Cisco Technology, Inc.
and/or its affiliated entities, under various laws including copyright, international treaties, patent,
and/or contract. Any use of the material herein must be in accordance with the terms of the License.
All rights not expressly granted by the License are reserved.

Unless required by applicable law or agreed to separately in writing, software distributed under the
License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
express or implied.
"""
# pylint: disable=import-error
import sys
import getopt
import time
import random
import ssl
import json
import avro.schema
import avro.io
from kafka import KafkaProducer

# Path to user.avsc avro schema
# pylint: disable=invalid-name
schema_path = "/opt/pnda/dataplatform-raw.avsc"

# Kafka topic
topic = "raw.log.localtest"
schema = avro.schema.parse(open(schema_path).read())

extra = False
loopMode = False
rangeValue = 1
sslEnable = False

current_milli_time = lambda: int(round(time.time() * 1000))

# pylint: disable=superfluous-parens
try:
    opts, args = getopt.getopt(sys.argv[1:], "he:lz", ["extra=", "loop="])
except getopt.GetoptError:
    print('producer.py [-e true] [-l true] [-z]')
    sys.exit(2)

for opt, arg in opts:
    if opt == '-h':
        print('producer.py [-e true] [-l true]')
        sys.exit()
    elif opt in ("-e", "--extra"):
        print("extra header requested")
        extra = True
    elif opt in ("-l", "--loop"):
        print("loop mode")
        loopMode = True
        rangeValue = 1000
    elif opt in ("-z"):
        sslEnable = True

extrabytes = bytes('')

# pylint: disable=no-member
if sslEnable:
    print("setting up SSL to PROTOCOL_TLSv1")
    ctx = ssl.SSLContext(ssl.PROTOCOL_TLSv1)
    ctx.load_cert_chain(certfile="../ca-cert", keyfile="../ca-key", password="test1234")
    producer = KafkaProducer(bootstrap_servers=["ip6-localhost:9093"], security_protocol="SASL_SSL",\
                             ssl_context=ctx,\
                             sasl_mechanism="PLAIN", sasl_plain_username="test", sasl_plain_password="test")
else:
    producer = KafkaProducer(bootstrap_servers=["localhost:9092"])

for i in xrange(rangeValue):
    #Prepare our msg data
    rawvarie = "python-random-"+str(random.randint(10, 10000))+"-loop-"+str(i)
    data = {"timestamp": current_milli_time(), "src": "ESC", "host_ip": "my_ipv6", "rawdata": rawvarie}
    producer.send(topic, json.dumps(data))
    if rangeValue > 1:
        time.sleep(0.5)
