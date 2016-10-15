#!/bin/sh
touch /root/qaz.txt
mv /tmp/sip_config/network_interfaces /etc/network/interfaces
/etc/init.d/networking start
rc-update add networking
apk update 
setup-sshd -c openssh 
/etc/init.d/sshd start
