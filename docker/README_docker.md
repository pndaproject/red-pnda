# red-pnda

<img src="logo/pnda1r-trans.png" alt="Red PNDA logo" width="400" height="300"/>

This framework provisions a minimal set of the PNDA ([pnda.io](http://pnda.io)) components to enable developers writing apps targeted at the full PNDA stack, to experiment with the PNDA components in a smaller, lightweight environment. Data exploration and app prototyping is supported using Jupyter and Apache Spark. 

**Note**: 

* Packages and application support isn't available on red-pnda. The respective tabs will **not** work on the PNDA console and will throw an error message.

* This framework is not implemented with either scalability nor HA in mind and hence is unsuited for running production workloads. If this is a requirement, then one of the core PNDA flavors will be required - see PNDA [Guide](http://pnda.io/guide).


The Red PNDA framework is intended as a platform for experimentation and is NOT formally supported at this point in time. Any issues encountered with the system can be reported to the standard PNDA support forums for informational purposes only.

## Acknowledgement

This work has been inspired by an initial concept created by Maros Marsalek ([https://github.com/marosmars](https://github.com/marosmars)) and Nick Hall ([https://github.com/cloudwiser](https://github.com/cloudwiser))

## Prerequisites

Tested with Ubuntu 18.04 distro.
 
Docker Engine (tested with docker version **18.05.0-ce**)

docker-compose (tested with docker-compose version **1.21.2**)


Minimum amount of RAM / VCPU / Storage: TBD

## Deploying red-PNDA as docker containers

The `deploy.sh` script start the containers and perform several post deploy tasks (e.g., creating users, initializing DDBB tables, etc.). Just inspect the script for more information.

To access the PNDA services from the host, the script appends `service-name IP-address` to the /etc/hosts file.

After deployment access the [PNDA console-frontend Web](http://console-frontend).

Default user is `pnda` and password `pnda`.

Other service web UIs:

* [Spark](http://spark-master:8080)
* [Kafka-manager](http://kafka-manager:10900)
* [HDFS](http://hdfs-namenode:50070)
* [HBASE](http://hbase-master:60010)
* [Jupyter](http://jupyter:8000)
* [Grafana](http://grafana:3000)
* [OpenTSDB](http://opentsdb:4242)

### Terminal access to running containers

You should be able to access a bash terminal in any of the running 
containers through the `docker exec -ti CONTAINER_NAME /bin/bash` command. 

### Access to service logs
You should be able to get the logs of any of the running 
containers through the `docker logs CONTAINER_NAME` command. 

## Red-PNDA components

Red-PNDA makes use the following open source components:

* Console Frontend - [https://github.com/pndaproject/platform-console-frontend](https://github.com/pndaproject/platform-console-frontend)
* Console Backend - [https://github.com/pndaproject/platform-console-backend](https://github.com/pndaproject/platform-console-backend)
* Platform Testing - [https://github.com/pndaproject/platform-testing](https://github.com/pndaproject/platform-testing)
* Platform Libraries - [https://github.com/pndaproject/platform-libraries](https://github.com/pndaproject/platform-libraries)
* Kafka 1.0.0 - [http://kafka.apache.org](http://kafka.apache.org)
* Jupyter Notebook - [http://jupyter.org](http://jupyter.org)
* Apache Spark 2.3.1 - [http://spark.apache.org](http://spark.apache.org)
* Apache Hbase 1.2.0 - [http://hbase.apache.org](http://hbase.apache.org)
* OpenTSDB 2.2.0 - [http://opentsdb.net](http://opentsdb.net)
* Grafana 4.3.1 - [https://grafana.com](https://grafana.com)
* Kafka Manager 1.3.3.6 - [https://github.com/yahoo/kafka-manager](https://github.com/yahoo/kafka-manager)
* Example Kafka Clients - [https://github.com/pndaproject/example-kafka-clients](https://github.com/pndaproject/example-kafka-clients)
* Jmxproxy 3.2.0 - [https://github.com/mk23/jmxproxy](https://github.com/mk23/jmxproxy)

## Data Ingestion

For instructions on how to use logstash to ingest data, refer to this [guide](../logstash_guide.md)

For detailed instructions on different data ingress methods, refer to this [guide](http://pnda.io/pnda-guide/producer/)

### Kafka

#### How to connect to red-pnda kafka instance?

To connect to the red-pnda kafka instance, you can connect to the broker on `kafka:9092`.

#### Are there any default topics which I can use?

By default, there are two kafka topics created for easy usage.

1. raw.log.localtest
2. avro.log.localtest

The `raw.log.localtest` topic is a generic topic; you could use this topic to ingest any type of data.

The `avro.log.localtest` topic can be used to ingest PNDA avro encoded data.

Note that if you use the `raw.log.localtest` topic, data is written to the disk of the VM.

By default data is stored in the `/data` directory of the VM's file system using a system-timestamp directory hierarchy

For example, if you streamed data on 20th June 2017 at 5PM, your data will be stored in...

    /data/year=2017/month=6/day=20/hour=17/dump.json

#### Sample Kafka Producer

We have also provided a sample Kafka producer in python. This will send one json event to the `raw.log.logtest` topic per execution, so feel free to play around with it.

    cd /opt/pnda
    python producer.py
    
Depending on what time you send the data, it will be stored in

    /data/year=yyyy/month=mm/day=dd/hour=hh/dump.json
    
Where yyyy,mm,dd and hh can be retreived by using the system date command

    date
    

## Jupyter Notebooks

The [Jupyter Notebook](http://jupyter.org) is a web application that allows you to create and share documents that contain live code, equations, visualizations and explanatory text. In Red PNDA, it supports exploration and presentation of data from the local file system.

The default password for the Jupyter Notebook is `pnda`

Please refer to our [Jupyter Guide](../jupyter_guide.md) for steps on how to use Jupyter

For those who are new to PNDA, there’s a network-related dataset (BGP updates from the Internet) and an accompanying tutorial Juypter notebook named `Introduction to Big Data Analytics.ipynb`, to help you get started.

Also, there's a sample tutorial named `tutorial.ipynb` provided to do some basic analysis with data dumped to disk via Kafka through Spark DataFrames.

If you are interested in data mining or anomaly detection, take a look at the `red-pnda-anom-detect.ipynb` where we work with telemetry data and try and detect unintentional traffic loss in the network.

## Grafana Server

Default login credentials for Grafana is `pnda/pnda`


## Shutdown

To stop docker PNDA services run `docker-compose down`.
 
To remove the docker PNDA containers run `docker-compose rm`.

To delete the PNDA docker persistent volumes run `./delete_volumes.sh`.


## General Troubleshooting

Please refer to our [Troubleshooting guide](../General_Troubleshooting.md) for tips if you encounter any problems.


## Further Reading

For further deep dive into the various components, use this as a entry point.

* Jupyter Notebooks, this guide which contains a nice intro to Jupyter as well: [https://github.com/jakevdp/PythonDataScienceHandbook](https://github.com/jakevdp/PythonDataScienceHandbook)

* OpenTSDB: [http://opentsdb.net/docs/build/html/user_guide/quickstart.html](http://opentsdb.net/docs/build/html/user_guide/quickstart.html)

* Grafana: [http://docs.grafana.org/guides/getting_started/](http://docs.grafana.org/guides/getting_started/)

* Kafka Manager: [https://github.com/yahoo/kafka-manager](https://github.com/yahoo/kafka-manager)

* Apache Spark: [https://spark.apache.org/docs/1.6.1/quick-start.html](https://spark.apache.org/docs/1.6.1/quick-start.html)
