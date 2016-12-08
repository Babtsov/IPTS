#!/bin/sh
rm /etc/network/interfaces
touch /etc/network/interfaces
cp /root/sip_config/sip_network_interfaces /etc/network/interfaces
service networking restart
apk add acf-postgresql