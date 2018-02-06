# red-pnda

<img src="logo/pnda1r-trans.png" alt="Red PNDA logo" width="400" height="300"/>

This framework provisions a minimal set of the PNDA ([pnda.io](http://pnda.io)) components to enable developers writing apps targeted at the full PNDA stack, to experiment with the PNDA components in a smaller, lightweight environment. Data exploration and app prototyping is supported using Jupyter and Apache Spark. 

Note - this framework is not implemented with either scalability nor HA in mind and hence is unsuited for running production workloads. If this is a requirement, then one of the core PNDA flavors will be required - see PNDA [Guide](http://pnda.io/guide).

The Red PNDA framework is intended as a platform for experimentation and is NOT formally supported at this point in time. Any issues encountered with the system can be reported to the standard PNDA support forums for informational purposes only.

## Acknowledgement

This work has been inspired by an initial concept created by Maros Marsalek ([https://github.com/marosmars](https://github.com/marosmars)) and Nick Hall ([https://github.com/cloudwiser](https://github.com/cloudwiser))

## Prerequisites

Tested with Ubuntu 14.04.5 distro.

VirtualBox minimum version : **5.1.14**

VMWare Fusion: **8.5.x**

Minimum amount of RAM / VCPU / Storage: **4GB / 2 VCPUs / 8GB**

## Running the OVA

The latest OVA image can be downloaded from [here](http://d5zjefk3wzew6.cloudfront.net/Red-PNDA_0.2.4.ova)

If you are installing the OVA file on Virtualbox, please refer to [Installing on VirtualBox Guide](installing_on_vbox_guide.md).

If you are installing the OVA file on VMware Fusion, please refer to [Installing on Fusion Guide](installing_on_fusion_guide.md).

Please note that we have yet to test the OVA on other virtualized environments e.g. deploying via vSphere on VMWare ESXi. Successful deployment in such environments are likely to be dependent on specific hardware compatiility as well as needing manual network interface mapping.

## MD5 checksum

The md5 hash of the latest Red PNDA .OVA file can be found at [md5_checksum.md](https://github.com/pndaproject/red-pnda/blob/master/md5_checksum.md)
    
Please check that the md5 checksum is the same. If it doesn't match, it usually means the download was corrupted and you might have to re-download the file.

On Mac, to find out the md5 checksum, open a terminal window and enter the following command:

    md5 <path-to-ova-file>
    
On Linux, to find out the md5 checksum, open a terminal window and enter the following command:
    
    md5sum <path-to-ova-file>

Please note that Windows does not have a native md5 checksum application. Please use a third-party application such as [HashCheck](http://code.kliu.org/hashcheck/).

## VM SSH access

If you are using Mac or Linux OS, you should be able to connect to the Red-PNDA VM using ssh from your host machine to the host-only/bridged adapter IP address of the VM. 

If you are using Windows, consider using [PuTTY](http://www.putty.org) to connect via ssh to the host-only/bridged adapter IP address of the Red-PNDA VM.

## Red-PNDA components

Red-PNDA makes use the following open source components:

* Console Frontend - [https://github.com/pndaproject/platform-console-frontend](https://github.com/pndaproject/platform-console-frontend)
* Console Backend - [https://github.com/pndaproject/platform-console-backend](https://github.com/pndaproject/platform-console-backend)
* Platform Testing - [https://github.com/pndaproject/platform-testing](https://github.com/pndaproject/platform-testing)
* Platform Libraries - [https://github.com/pndaproject/platform-libraries](https://github.com/pndaproject/platform-libraries)
* Kafka 0.11.0.0 - [http://kafka.apache.org](http://kafka.apache.org)
* Jupyter Notebook - [http://jupyter.org](http://jupyter.org)
* Apache Spark 1.6.1 - [http://spark.apache.org](http://spark.apache.org)
* Apache Hbase 1.2.0 - [http://hbase.apache.org](http://hbase.apache.org)
* OpenTSDB 2.2.0 - [http://opentsdb.net](http://opentsdb.net)
* Grafana 4.3.1 - [https://grafana.com](https://grafana.com)
* Kafka Manager 1.3.3.6 - [https://github.com/yahoo/kafka-manager](https://github.com/yahoo/kafka-manager)
* Example Kafka Clients - [https://github.com/pndaproject/example-kafka-clients](https://github.com/pndaproject/example-kafka-clients)
* Jmxproxy 3.2.0 - [https://github.com/mk23/jmxproxy](https://github.com/mk23/jmxproxy)

## Data Ingestion

For instructions on how to use logstash to ingest data, refer to this [guide](logstash_guide.md)

For detailed instructions on different data ingress methods, refer to this [guide](http://pnda.io/pnda-guide/producer/)

### Kafka

#### How to connect to red-pnda kafka instance?

**IMPORTANT**: To connect to the kafka instance running on red-pnda, you need to edit the config file and advertise your IP address like so:

    sudo vim $KAFKA_HOME/config/server.properties

Scroll down to line 141 and replace it with your IP address. In this example, `192.168.33.10` is my red-pnda IP address:

    listeners=INGEST://192.168.33.10:9094,REPLICATION://127.0.0.1:9093,INTERNAL_PLAINTEXT://192.168.33.10:9092
    advertised.listeners=INGEST://192.168.33.10:9094,REPLICATION://127.0.0.1:9093,INTERNAL_PLAINTEXT://192.168.33.10:9092

Save and quit. Then restart kafka service.

    sudo service kafka restart

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

Please refer to our [Jupyter Guide](jupyter_guide.md) for steps on how to use Jupyter

For those who are new to PNDA, there’s a network-related dataset (BGP updates from the Internet) and an accompanying tutorial Juypter notebook named `Introduction to Big Data Analytics.ipynb`, to help you get started.

Also, there's a sample tutorial named `tutorial.ipynb` provided to do some basic analysis with data dumped to disk via Kafka through Spark DataFrames.

## Grafana Server

Default login credentials for Grafana is `pnda/pndapnda`

## Local Documentation

A copy of this documentation is also available in the Red PNDA OVA at `/home/pnda/red-pnda-develop`.

## Shutdown

Suspending the VM is not supported. Please reboot or do a clean shutdown of the VM.

To shutdown the VM in VBox, right-click on the VM and click on `Close -> Power Off` to do a graceful shutdown.

In Fusion, Click on `Virtual Machine` tab on the main menu and click on `Shutdown`

## General Troubleshooting

Please refer to our [Troubleshooting guide](General_Troubleshooting.md) for tips if you encounter any problems.

## Roll your own Red PNDA

If you are interested in creating your own Red PNDA, either on your local machine or in a VM without installing the .OVA file, please refer to this [guide](roll_your_own_RED_PNDA.md) for further details.



## Further Reading

For further deep dive into the various components, use this as a entry point.

* Jupyter Notebooks, this guide which contains a nice intro to Jupyter as well: [https://github.com/jakevdp/PythonDataScienceHandbook](https://github.com/jakevdp/PythonDataScienceHandbook)

* OpenTSDB: [http://opentsdb.net/docs/build/html/user_guide/quickstart.html](http://opentsdb.net/docs/build/html/user_guide/quickstart.html)

* Grafana: [http://docs.grafana.org/guides/getting_started/](http://docs.grafana.org/guides/getting_started/)

* Kafka Manager: [https://github.com/yahoo/kafka-manager](https://github.com/yahoo/kafka-manager)

* Apache Spark: [https://spark.apache.org/docs/1.6.1/quick-start.html](https://spark.apache.org/docs/1.6.1/quick-start.html)
