# IPTS installation Scripts 
This repository contains scripts that try to configure the IPTS system automatically as much as possible. Please follow the following instructions to configure the system:
* prepare your bootable USB and add the directory of this repository to the root of the USB (along with the Alpine Linux image)
* Run the following script which configures the system networking as well as installing and running all the different containers:
```bash
cd /media/usb/IPTS
./install.sh
```
* Use `lxc-console -n [container name]` to go inside each container, and execute each container's installation script (provided in a directory in each container's home directory)  

## note
These scripts were tested on Alpine 3.4.6 (iso size: 81MB)  
