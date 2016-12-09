#!/bin/sh
echo 'CONFIGURING NETWORK'
rm /etc/network/interfaces
touch /etc/network/interfaces
cp /root/provisioning_config/provisioning_network_interfaces /etc/network/interfaces
service networking restart

rc-update add networking