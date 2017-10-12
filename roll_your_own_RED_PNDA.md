# Roll your own RED PNDA

## Prerequisities

**OS Prerequisite**

This guide assumes two thigs:

   1. your machine has access to the internet to install the various packages
   2. you are running on the Linux Ubuntu 14.04 distro. 

Other distros may work but we haven't tested against these yet

**RAM:** 4GB

**Disk Space:** Minimum 7GB

**CPUs:** 2 VCores preferred.

## Before we get started

Clone this repository into your local file system to copy the installation scripts:

    $ sudo apt-get install git
    $ git clone https://github.com/pndaproject/red-pnda.git

## Next Steps

The installation is driven by the **`scripts/install-dependencies.sh`** file which installs all the necessary dependencies and starts installing the required components one-by-one. But first...

Login as root:

    $ sudo su # this is important

**IMPORTANT:** If you're behind a proxy server, set the proxy ENV variables prior to running the script(s).

    $ export http_proxy="http://<your_http_proxy_server:port>"
    $ export https_proxy="https://<your_https_proxy_server:port>"

Check which reachable network interface(s) you have available:

    $ /sbin/ifconfig -a

Then execute the install script:

    $ cd red-pnda
    $ bash scripts/install-dependencies.sh <reachable-network-interface from previous e.g. eth0 or eth1>

Grab a coffee as it might take a while but, once it's done, reboot your system once:

    $ sudo reboot

If the opentsdb service doesn't start, it might require a forced restart as it can be a bit finicky...so execute the following script:

    $ sudo bash /opt/pnda/zk-opentsdb-restart.sh
    
Go to your browser and type `http://<your_ip_address>` to view the PNDA console.

**Note:** If you are using AWS or any other cloud provider, refer to this [guide](Connecting_on_cloud.md)

Congratulations...you should now have a successfully-installed-and-running Red PNDA! 

If you do hit problems though, please raise an issue here

## Development

Alternatively, for development purposes, you can start the PNDA console in local mode:

    $ cd /opt/pnda/console-frontend
    $ sudo npm install -g grunt-cli
    $ grunt
    $ grunt serve

Go to your browser and type `http://<your_ip_address>:8006` to view the console.
