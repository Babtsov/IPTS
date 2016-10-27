#!/bin/sh
rm /etc/network/interfaces
cp sip_config/network_interfaces /etc/network/interfaces
service networking start
rc-update add networking
ping www.google.com -t 3
