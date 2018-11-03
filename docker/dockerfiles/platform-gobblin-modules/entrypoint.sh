#!/bin/bash

j2 /mr.pull.tpl > /etc/gobblin/mr.pull
j2 /mr.compact.tpl > /etc/gobblin/mr.compact
/gobblin-dist/bin/gobblin-standalone.sh start