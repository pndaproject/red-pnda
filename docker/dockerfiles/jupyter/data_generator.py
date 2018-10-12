#!/usr/bin/python

import argparse
import subprocess
import json
import avro.schema
import avro.io
import io
import datetime
import uuid
import time
import sys

from random import randint
from avro.datafile import DataFileWriter
from avro.io import DatumWriter
from argparse import RawTextHelpFormatter

def generate_sample_datasets (host_ips, metric_ids, year, month, day, hour):
    avro_schema = ''
    #load data from hdfs
    cat = subprocess.Popen(['sudo', '-u', 'hdfs', 'hadoop', 'fs', '-cat', '/user/pnda/PNDA_datasets/datasets/.metadata/schema.avsc'], stdout=subprocess.PIPE)
    for line in cat.stdout:
        avro_schema = avro_schema + line
    schema = avro.schema.parse(avro_schema)
    bytes_writer = io.BytesIO()
    encoder = avro.io.BinaryEncoder(bytes_writer)
    #create hdfs folder structure
    dir = create_hdfs_dirs (year, month, day, hour)
    filename = str(uuid.uuid4()) + '.avro'
    filepath = dir + filename
    tmp_file = '/tmp/' + filename
    
    writer = DataFileWriter(open(tmp_file, "w"), DatumWriter(), schema)
    
    start_dt = datetime.datetime(year, month, day, hour, 0, 0) 
    start_ts = int(time.mktime(start_dt.timetuple()))
    end_dt = start_dt.replace(hour=hour+1)
    end_ts = int(time.mktime(end_dt.timetuple()))

    for ts in xrange(start_ts, end_ts, 1):
        #generate random pnda record on per host ip basis
        for host_ip in host_ips:
           record = {}
           record['timestamp'] = (ts * 1000)
           record['src'] = 'test'
           record['host_ip'] = host_ip
           record['rawdata'] = generate_random_metrics(metric_ids)
           #encode avro
           writer.append(record)
    writer.close()
    subprocess.Popen(['sudo', '-u', 'hdfs', 'hadoop', 'fs', '-copyFromLocal', tmp_file, dir])
    return filepath

def generate_random_metrics (metric_ids):
    '''
        generate random raw_data elementTon
    '''
    raw_data = {}
    for id in metric_ids:
        raw_data[id] = str(randint(0, 100))
    return json.dumps(raw_data).encode('utf-8')

def create_hdfs_dirs (year, month, day, hour):
    dir = "/user/pnda/PNDA_datasets/datasets/source=test/year=%0d/month=%02d/day=%02d/hour=%02d/" % (year, month, day, hour)
    subprocess.Popen(['sudo', '-u', 'hdfs', 'hadoop', 'fs', '-mkdir', '-p', dir])
    return dir    

def get_args():
    epilog = """ example:
    - create sample data sets
      data_generator.py --hosts '10.0.0.1, 10.0.0.2' --metrics 'a, b, c' --year 2016 --month 4 --day 27 --hour 14
    - create sample data sets using system datetime
      data_generator.py --hosts '10.0.0.1, 10.0.0.2' --metrics 'a, b, c'
    """
    
    dt = datetime.datetime.now()
    parser = argparse.ArgumentParser(formatter_class=RawTextHelpFormatter, description='Sample datasets generator', epilog=epilog)
    parser.add_argument('--hosts', help='list of sample host ips separated by comma', default='')
    parser.add_argument('--metrics', help='list of metrics ids', default='')
    parser.add_argument('--year', type=int, help='year', default=dt.year)
    parser.add_argument('--month', type=int, help='month', default=dt.month)
    parser.add_argument('--day', type=int, help='day of the month', default=dt.day)
    parser.add_argument('--hour', help='hour of the day', default=dt.hour)
    args = parser.parse_args()
    return args

def main():
    args = get_args() 
    hosts = args.hosts.strip()
    if not hosts:
        print 'mandatory arg --hosts missing (aborting).'
        sys.exit()
    
    host_ips = [x.strip() for x in hosts.split(",")]
    
    metrics = args.metrics.strip()
    if not metrics:
        print 'mandatory arg --metrics missing (aborting).'
        sys.exit()
    metric_ids = [x.strip() for x in metrics.split(",")]
    
    year = int(args.year)
    month = int(args.month)
    day = int(args.day)
    hour = int(args.hour)
    filepath = generate_sample_datasets(host_ips, metric_ids, year, month, day, hour)
    print "Success: generated file path at " + filepath

if __name__ == "__main__":
    main()
              
      
    