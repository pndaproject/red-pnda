# Installing on VirtualBox Guide

If you don't have VirtualBox installed, please download it [here](https://www.virtualbox.org/wiki/Downloads) and follow the appropriate installation instructions for your host computer's operating system.

## Detailed How To

**Step 0:** Before we begin, it's important to have a host-only network set up on Virtualbox.
If you don't have one, go to Preferences -> Network -> Host-Only Networks

<img src="images/virtualbox_images/host_only_1.png" alt="Step 1" style="width: 300px;"/>

If the list is empty, please click on the Add button the right to create a Host-Only network.

You should see something like this:

<img src="images/virtualbox_images/host_only_2.png" alt="Step 1" style="width: 300px;"/>

Click on DHCP Server tab and click on Enable Server.

<img src="images/virtualbox_images/host_only_3.png" alt="Step 1" style="width: 300px;"/>

Click Ok and exit.

**Step 1:** Open VirtualBox and select File -> Import Appliance from the menu.

<img src="images/virtualbox_images/VBox_Step_1.png" alt="Step 1" style="width: 600px;"/>

**Step 2:** Select the Red PNDA OVA file from its current location.

<img src="images/virtualbox_images/VBox_Step_2.png" alt="Step 2" style="width: 600px;"/>

Click "Continue"

**Step 3:** Click "Import". It is not recommended to adjust the default OVA settings.

<img src="images/virtualbox_images/VBox_Step_3.png" alt="Step 3" style="width: 600px;"/>

**Step 4:** You should now see the Virtual Machine image installed and ready to go.

<img src="images/virtualbox_images/VBox_Step_4.png" alt="Step 4" style="width: 600px;"/>

**Step 5:** It is recommended that you create a 'linked clone' of the base VM. In case there's a problem, you are able to quickly create a new working image without reinstalling from the OVA file.

<img src="images/virtualbox_images/VBox_Step_5.png" alt="Step 5" style="width: 600px;"/>

Click "Continue"

**Step 6:** Click on "Linked Clone" and click "Clone".

<img src="images/virtualbox_images/VBox_Step_6.png" alt="Step 6" style="width: 600px;"/>

**Step 7:** Press "Start" to boot the cloned VM.

**Step 8:** Use the default credentials (pnda/pnda) to login.

**Step 9:** Run `ifconfig` command to check which network interface is reachable from host machine. In this example `eth0` is the active interface.

<img src="images/virtualbox_images/VBox_Step_8.png" alt="Step 8" style="width: 600px;"/>

**Step 10:** Run the following command:

    sudo sh assign-ip.sh eth0

If prompted for a password, enter `pnda`

<img src="images/virtualbox_images/VBox_Step_9.png" alt="Step 9" style="width: 600px;"/>

Open a browser and navigate to reachable address. In this example, the address is `192.168.56.101`:

<img src="images/virtualbox_images/chrome_browser.png" alt="Step 10" style="width: 600px;"/>

Congratulations! You've successfully installed Red PNDA.

## Important 

By default a 'host-only' network adapter is provided. By using this type of adapter, you’ll be able to access a private, virtual network consisting solely of your host and any guest virtual machines. Any of the guest virtual machines can access each other, but you can't access outside traffic i.e. reach the Internet.

If you need internet access, you have two options:

* Consider changing the network adapter's 'attached to' setting from 'Host-Only' to 'Bridged'.

<img src="images/virtualbox_images/bridged_adapter.png" alt="Bridged Adapter" style="width: 600px;"/>

*  Add a second adapter with the adapter's 'attached to' setting set to 'NAT'.

<img src="images/virtualbox_images/nat_adapter.png" alt="NAT" style="width: 600px;"/>

If you do add a second network adapter, be careful not be specify the interface listing `eth0` IP for the Step 9 listed above.

Be sure to reboot your VM if you change the network settings and run the `assign-ip.sh` script as shown in Step 10 above.
