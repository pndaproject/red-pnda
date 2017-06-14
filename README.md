# red-pnda

<img src="logo/pnda1r-trans.png" alt="Red PNDA logo" style="width: 30px;"/>

This framework provisions a minimal set of the PNDA ([pnda.io](http://pnda.io)) components to enable developers writing apps targeted at the full PNDA stack. Data exploration and app prototyping are supported via Jupyter and Apache Spark respectively. 

Note this framework is not implemented with either scalability nor HA in mind and hence is unsuited for running production workloads. If this is a requirement, then one of the core PNDA flavors will be required - see PNDA [Guide](http://pnda.io/guide).

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

If you are using Mac or Linux OS, you should be able to ssh into the VM from your host machine by using the host-only/bridged adapter IP address.

If you are using Windows, consider using [PuTTY](http://www.putty.org) to ssh by using the host-only/bridged adapter IP address.

## Red-PNDA components

We use the following open source components:

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

By default, there are two kafka topics created before hand for easy usage.

1. raw.log.localtest
2. avro.log.localtest

The `raw.log.localtest` topic is a generic topic, you could use it to ingest any type of data.

The `avro.log.localtest` topic can be used to ingest PNDA avro encoded data.

If you use the `avro.log.localtest` topic, we flush the data to disk on the VM.

By default, we store data on the `/data` directory.

For example, if you streamed some avro encoded data on 20th June 2017 at 5PM, your data will be stored in

    /data/year=2017/month=6/day=20/hour=17/dump.avro
     
 directory structure.
 
If you want to use logstash to ingest avro encoded data, refer to our [Logstash guide](Logstash_guide.md).

