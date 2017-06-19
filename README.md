# red-pnda

<img src="logo/pnda1r-trans.png" alt="Red PNDA logo" style="width: 30px;"/>

This framework provisions a minimal set of the PNDA ([pnda.io](http://pnda.io)) components to enable developers writing apps targeted at the full PNDA stack, to experiment with the PNDA components in a smaller, lightweight environment. Data exploration and app prototyping is supported using Jupyter and Apache Spark. 

Note - this framework is not implemented with either scalability nor HA in mind and hence is unsuited for running production workloads. If this is a requirement, then one of the core PNDA flavors will be required - see PNDA [Guide](http://pnda.io/guide).

The Red PNDA framework is intended as a platform for experimentation and is NOT formally supported at this point in time. Any issues encountered with the system can be reported to the standard PNDA support forums for informational purposes only.

## Installation

Tested with Ubuntu 14.04.5 distro.

### Prerequisities
VirtualBox minimum version : **5.1.14**

VMWare Fusion: **8.5.x**

Minimum amount of RAM/VCPU/Storage: **4GB/2 VCPUs/8GB**

If you are installing the OVA file on Virtualbox, please refer to [Installing on VirtualBox Guide](installing_on_vbox_guide.md).

If you are installing the OVA file on VMware Fusion, please refer to [Installing on Fusion Guide](installing_on_fusion_guide.md).

## VM SSH access

If you are using Mac or Linux OS, you should be able to connect to the Red-PNDA VM using ssh from your host machine to the host-only/bridged adapter IP address of the VM. 

If you are using Windows, consider using [PuTTY](http://www.putty.org) to connect via ssh to the host-only/bridged adapter IP address of the Red-PNDA VM.

## Red-PNDA components

Red-PNDA makes use the following open source components:

* Console Frontend - [https://github.com/pndaproject/platform-console-frontend](https://github.com/pndaproject/platform-console-frontend)
* Console Backend - [https://github.com/pndaproject/platform-console-backend](https://github.com/pndaproject/platform-console-backend)
* Platform Testing - [https://github.com/pndaproject/platform-testing](https://github.com/pndaproject/platform-testing)
* Platform Libraries - [https://github.com/pndaproject/platform-libraries](https://github.com/pndaproject/platform-libraries)
* Kafka 0.10.2.0
* Jupyter Notebook.
* Apache Spark 1.6.1
* Apache Hbase 1.2.0
* OpenTSDB 2.2.0
* Grafana 4.3.1 
* Kafka Manager 1.3.3.6
* Example Kafka Clients - [https://github.com/pndaproject/example-kafka-clients](https://github.com/pndaproject/example-kafka-clients)
* Jmxproxy 3.2.0

## Data Ingestion

By default, there are two kafka topics created for easy usage.

1. raw.log.localtest
2. avro.log.localtest

The `raw.log.localtest` topic is a generic topic; you could use this topic to ingest any type of data.

The `avro.log.localtest` topic can be used to ingest PNDA avro encoded data.

Note that if you use the `avro.log.localtest` topic, data is flushed to the disk of the VM.

By default data is stored in the `/data` directory of the VM's filesystem.

For example, if you streamed avro-encoded data on 20th June 2017 at 5PM, your data will be stored in

    /data/year=2017/month=6/day=20/hour=17/dump.avro
     
 directory structure.

### Sample Kafka Producer

We have also provided a sample Kafka producer in python. This will send one avro encoded event to the `avro.log.logtest` topic per execution, so feel free to play around with it.

    cd /opt/pnda
    python producer.py
    
Depending on what time you send the data, it will be stored in

    /data/year=x/month=x/day=x/hour=x/dump.avro
    
If the data has been encoded correctly, then the Avro tools will be able to decode it without any errors. In this case, dump.avro contains some netflow data and our schema is in a file named dataplatform-raw.avsc

    root@red-pnda:/opt/pnda# java -jar avro-tools-1.7.7.jar fragtojson --schema-file dataplatform-raw.avsc /data/year=2017/month=6/day=14/hour=20/dump.avro
    {
      "timestamp" : 1497464526286,
      "src" : "ESC",
      "host_ip" : "my_ipv6",
      "rawdata" : "python-random-9343-loop-0"
    }

### Logstash

If you want to use Logstash to ingest avro-encoded data, refer to the [Logstash guide](Logstash_guide.md).

## Jupyter Notebooks

The [Jupyter Notebook](http://jupyter.org) is a web application that allows you to create and share documents that contain live code, equations, visualizations and explanatory text. In Red PNDA, it supports exploration and presentation of data from local FS and HBase.

Please refer to our [Jupyter Guide](jupyter_guide.md) for steps on how to use Jupyter

## Shutdown

Suspending the VM is not supported, please reboot or do a clean shutdown of the VM as an alternative.

To shutdown the VM in VBox, right-click on the VM and click on `Close -> Power Off` to do a graceful shutdown.

In Fusion, Click on `Virtual Machine` tab on the main menu and click on `Shutdown`

## General Troubleshooting

Please refer to our [Troubleshooting guide](General_Troubleshooting.md) for tips if you encounter any problems.

## Roll your own Red PNDA

If you are interested to roll your own Red PNDA either on your local machine or on the cloud without installing the .OVA file, then this one is for you.

Refer to this [guide](roll_your_own_RED_PNDA.md) for further details.

## Further Reading

For further deep dive into the various components, use this as a entry point.

* Jupyter Notebooks, this guide which contains a nice intro to Jupyter as well: [https://github.com/jakevdp/PythonDataScienceHandbook](https://github.com/jakevdp/PythonDataScienceHandbook)

* OpenTSDB: [http://opentsdb.net/docs/build/html/user_guide/quickstart.html](http://opentsdb.net/docs/build/html/user_guide/quickstart.html)

* Grafana: [http://docs.grafana.org/guides/getting_started/](http://docs.grafana.org/guides/getting_started/)

* Kafka Manager: [https://github.com/yahoo/kafka-manager](https://github.com/yahoo/kafka-manager)

* Apache Spark: [https://spark.apache.org/docs/1.6.1/quick-start.html](https://spark.apache.org/docs/1.6.1/quick-start.html)