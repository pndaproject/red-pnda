# Logstash guide

## About 

[Logstash](https://www.elastic.co/products/logstash) is a lightweight, open source data collection engine organized as simple pipeline with a large number of plugins. It has input plugins for Netflow, SNMP, collectd, syslog, etc. 

Logstash is used as to collect, enrich and transport data from multiple sources into PNDA.

## Installation

We recommend logstash 2.3.4 or one of the newer versions.

### Prerequisites

Install Java (if you haven't done so):

    sudo add-apt-repository ppa:webupd8team/java
    sudo apt-get update
    sudo apt-get install oracle-java8-installer

    
Create the source directory:
```sh
    mkdir -p /opt/logstash
    cd /opt/logstash
```

### Install logstash 2.3.4

    cd /opt/logstash
    wget https://download.elastic.co/logstash/logstash/logstash-2.3.4.tar.gz
    tar -zxvf logstash-2.3.4.tar.gz


## Example Configuration

As an example, we will see how to send any type of data to the red-pnda instance.
 
**Note:** Please replace the `bootstrap_servers` value with your red-pnda IP address. In my case, it is `192.168.33.10`

    input {
      stdin { }
    }
    filter {
    }
    output {
      kafka { 
        bootstrap_servers => "192.168.33.10:9092"
        topic_id =>  "raw.log.localtest"
      }
    }

Save the above configuration in `logstash.conf`.

Then run logstash:

    cd logstash-2.3.4/
    bin/logstash agent -f logstash.conf


You should see a `Logstash startup completed` message printed on the console. If you don't see this message, something went wrong in your setup or there's an error in your config.

Inject one line per event:

    this is raw data
    test message

In your red-pnda machine, navigate to:

    cd /data/year=<year>/month=<month>/day=<day>/hour=<hour>
    cat dump.json

where `year, month, day` is the output of the `date` command i.e. current machine timestamp.

You should be able to see the syslog event we just sent.
