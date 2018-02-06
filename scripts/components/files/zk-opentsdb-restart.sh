#!/bin/bash
UP=$(sudo service opentsdb status|grep 'is running' | wc -l);
echo "$UP"
if [ "$UP" -ne 1 ];
then
    echo "OpenTSDB is down.";
    sudo service opentsdb restart

else
    echo "All is well.";
fi