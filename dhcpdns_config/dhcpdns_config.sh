#!/bin/sh
echo 'CONFIGURING NETWORK'
rm /etc/network/interfaces
touch /etc/network/interfaces
cp /root/dhcpdns_config/dhcpdns_network_interfaces /etc/network/interfaces
service networking restart

rc-update add networking

apk update && apk upgrade
echo 'CONFIGURING ssh'
setup-sshd -c openssh 
/etc/init.d/sshd start
setup-acf
echo 'INSTALLING the dhcpd package'
apk add acf-dhcp
echo 'ADDING dhcpd.conf'
cp /root/dhcpdns_config/dhcpd.conf /etc/dhcpd.conf

# Start DHCP service and add to runlevel default
rc-service dhcpd start  
rc-update add dhcpd

# install TinyDNS and DNScache packages
apk add acf-tinydns acf-dnscache
echo 'COPYING the DNS file'
cp /root/dhcpdns_config/dns_data /etc/tinydns/data

# Start TinyDNS service and add to runlevel default
rc-service tinydns start  
rc-update add tinydns

# Start DNScache service and add to runlevel default
rc-service dnscache start  
rc-update add dnscache
