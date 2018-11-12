#!/bin/sh
j2 /server.conf.tpl > /data-service/server.conf
cd /data-service
python apiserver.py
