# IPTS installation Scripts 
This repository contains scripts that configure the IPTS system automatically.  
Please follow the following instructions to configure the system:
* prepare your bootable USB and add the directory of this repository to the root of the USB (along with the Alpine Linux image).
* Boot Alpine Linux from a USB drive (make sure to change BIOS settings or boot order, if needed) 
* login to the system as the root user. (for a fresh installation, username it just `root` and no password is needed)
* Run the following script, which will start the configuration of the system (make sure to run it as root):
```bash
cd /media/usb/IPTS
./install.sh
```
* As the script executes the setup, it will create a log file for each container that it creates. If needed, the log files can be examined in order to troubleshoot errors and to make sure all the components were configured poperly.

## Notes
These scripts were tested on Alpine 3.4.6 (iso size: 81MB)  
