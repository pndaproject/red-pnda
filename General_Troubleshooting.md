# General Troubleshooting

#### Q. Which ports are being used by various services?

* Kafka Manager is on the port `10900` 
* OpenTSDB is on port `4242`
* Grafana Server is on port `3000`
* Spark Web UI is on port `8080`
* Jupyter is on port `9000`

#### Q. What's the login credentials for the Grafana Server?

Use `pnda/pndapnda` as the login credentials.

#### Q. Why isn't Packages, Apps and Datasets tabs active on the Console Tab?

Red PNDA currently doesn't include the services which provide those functionalities.

#### Q. Kafka/Zookeeper turns grey/red on the console after start up. What should I do?

Please execute this command on the VM terminal. 

    bash /opt/pnda/zk-opentsdb-restart.sh

Restarting Zookeeper should fix the problem. You should see Kafka turning back to green after a minute.

#### Q. How can I run my spark application on Red PNDA?

If you have built a jar containing all the necessary libs, you can simply scp the jar to the VM and run it with the `spark-submit` command.

#### Q. Where are all the service logs available?

All component logs are generally available at `/var/log/` for debugging purposes. 

However, hbase logs are at `/usr/local/hbase-1.2.0/logs/` directory.


#### Q. OpenTSDB doesn't start on boot.

OpenTSDB might be a bit finicky sometimes, run this script to restart zk and opentsdb. 98% of the times it solves the problem

    bash /opt/pnda/zk-opentsdb-restart.sh
   
#### Q. Kafka/Zookeeper is grey and not changing color for long time.

We've noticed that as well and are currently investigating what's causing this. Not sure if it's caused by the system being on idle state for too long.

For now, the best thing to do is to reboot the VM.

#### Q. Can I upgrade the Ubuntu OS?

We are currently running Ubuntu 14.04 but its not advisable to upgrade the OS to the newer version as several init scripts won't run as expected i.e. please refrain from doing a `sudo apt-get upgrade`

But `sudo apt-get update` should be fine and shouldn't cause any issues.
