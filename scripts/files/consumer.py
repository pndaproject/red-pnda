"""
Name:       Sample python code for Kafka Client
Purpose:    Consuming messages from Kafka topics

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

import threading, logging, time, io, os
import sys, traceback, struct
import getopt
from StringIO import StringIO
import avro.schema
import avro.io
from kafka import KafkaConsumer, TopicPartition
import ssl
import datetime
import errno

# Path to user.avsc avro schema
schema_path = "/opt/pnda/dataplatform-raw.avsc"
schema_id = 23
schema = avro.schema.parse(open(schema_path).read())
useextra = False
useavro = False
sslEnable = False
jsonFileName = "dump.json"
base_dir = "/data"

#make base dir
now = datetime.datetime.now()
dest_path = base_dir + "/year=" + str(now.year) + "/month=" + str(now.month) + "/day=" + str(now.day) + "/hour=" + str(now.hour)
dest_file = dest_path + "/" + jsonFileName
try:
  os.makedirs(dest_path)
except OSError as exception:
  if exception.errno != errno.EEXIST:
    raise
# open file for writing
f = open(dest_file, 'a')

def consume_message(message):

  newmessage = message.value
  if not useavro:
    print(message.value)
    f.write(message.value)
    f.write("\n")
    f.flush()
  else:
    if useextra:
      print('<'*10)
      b = bytearray(newmessage)
      if b[0] != 0:
        print('-'*60)
        print("MAGIC_BYTE error")
        print('-'*60)
      else:
        print('Magic Byte match')

      ## Check schema Id
      ## This is a test program. If errors, do not stop the program
      ## but display Alerts
      if len(b) >= 5:
          b_schema_id=bytearray(b[1:5])
          b_schema = struct.unpack('>I', b_schema_id)[0]
          print("Read scheme Id: [",b_schema,"] expected: [",schema_id,"]")
          if b_schema != schema_id:
               print('!'*10)
               print("Schema IDs do not match")
      else:
          print("Cant decode byte array")

      ## Remove extra header for pure Avro Record binary decoding
      del b[0:5]
      newmessage=b

    bytes_reader = io.BytesIO(newmessage)
    decoder = avro.io.BinaryDecoder(bytes_reader)
    reader = avro.io.DatumReader(schema)
    msg = reader.read(decoder)

class Consumer(threading.Thread):
  daemon = True

  @classmethod
  def run(self):
    global useavro, useextra, schema_id, sslEnable
    print("start Consumer")

    if useavro:
     topic="avro.log.localtest"
    else:
     topic="raw.log.localtest"

    print("on topic %s" % topic)

    if sslEnable:
      print("setting up SSL to PROTOCOL_TLSv1")
      ctx = ssl.SSLContext(ssl.PROTOCOL_TLSv1)
      ctx.load_cert_chain(certfile="../ca-cert", keyfile="../ca-key", password="test1234")
      consumer = KafkaConsumer(bootstrap_servers=["ip6-localhost:9093"],security_protocol="SASL_SSL",ssl_context=ctx,\
    sasl_mechanism="PLAIN",sasl_plain_username="test",sasl_plain_password="test", group_id="test")
    else:
      consumer = KafkaConsumer(bootstrap_servers=["localhost:9092"])

    consumer.assign([TopicPartition(topic, 0)])

    ## Skip the consumer to the head of the log - this is a personal choice
    ## It mean we are loosing messages when the py consumer was off
    ## Not a problem for testing purposes
    #consumer.seek(0,2)

    for message in consumer:
      print('-'*60)
      try:
        consume_message(message)
      except:
          print('error')
          print('-'*60)
          traceback.print_exc(file=sys.stdout)
          print('-'*60)

def main(argv):
  global useavro, useextra, sslEnable
  try:
    opts, args = getopt.getopt(argv,"he:sz",["extra=", "serialized="])
  except getopt.GetoptError:
    print('consumer.py [-e|--extra true] [-s|--serialized true]')
    sys.exit(2)
  for opt, arg in opts:
    if opt == '-h':
     print('consumer.py [-e|--extra true] [-s|--serialized true]')
     sys.exit(0)
    elif opt in ("-e", "--extra"):
     print('extra header required')
     useextra=True
     print('extra set')
    elif opt in ("-s", "--serialized"):
     print('avro serialization required')
     useavro=True
    elif opt in ("-z"):
      print('SSL required')
      sslEnable=True


if __name__ == "__main__":
  logging.basicConfig(
      format='%(asctime)s.%(msecs)s:%(name)s:%(thread)d:%(levelname)s:%(process)d:%(message)s',
      level=logging.INFO
      )
  main(sys.argv[1:])
  Consumer().run()
  f.close()