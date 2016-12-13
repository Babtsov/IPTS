# IPTS installation Scripts 
This repository contains scripts that configure the IPTS system automatically. These scripts were tested on Alpine 3.4.6 (iso size: 81MB).      
<br />
Instructions to configure the system:
* prepare your bootable USB and add the directory of this repository to the root of the USB (along with the Alpine Linux image).
* Boot Alpine Linux from a USB drive (make sure to change BIOS settings or boot order, if needed) 
* login to the system as the root user. (for a fresh installation, username it just `root` and no password is needed)
* Run the following script, which will start the configuration of the system (make sure to run it as root):
```bash
cd /media/usb/IPTS
./install.sh
```
* As the script executes the setup, it will create a log file for each container that it creates. If needed, the log files can be examined in order to troubleshoot errors and to make sure all the components were configured poperly.

## IP Addresses of the containers:
dhcpdns container: 10.2.0.152  
provisioning container: 10.2.0.6  
sip container: 10.2.0.3  
sipmedia container: 10.2.0.81  
lxc-host container: 10.2.0.253

# SSH keys and remote login
The first time the system is configued (after `install.sh` script is run), lxc-host will have its SSH daemon configured to allow remote connections using a default key (which is included in this repository). Interacting with Alpine-Linux through SSH is a nice feature, as it makes the system more convenient to work with (at least, it's more convenient for some people).   
<br />
__IMPORTANT: before opening any ports to the public internet, make sure you remove the default key stored inside `~/.ssh/authorized_keys` on lxc-host. The default key is meant to be used when the system is used within a private network ONLY. If you intend to expose the system to the public internet, generate your own key-pair and put the public key into the `~/.ssh/authorized_keys` file on lxc-host. NEVER share your private key with anyone. Doing otherwise might compromise the system.__  
<br />
Instructions to SSH into the system using the default key (to be used within a private network):
* Copy the private key located in `host_config/ipts` to your `~/.ssh` directory (or some other convenient place).
* Make sure the permissions on the `ipts` files are correct. If not, try executing `chmod 600 ~/.ssh/ipts`
* SSH into the lxc-host by using the following:
```bash
ssh-keygen -R 10.2.0.253 # not needed if this is your computer's first time SSHing into lxc-host
ssh -i ~/.ssh/ipts root@10.2.0.253 # if needed, adjust the path to your private key
``` 



