# keep pressing enter to setup a default temporary networking interface (using dhcp)
printf "\n" | ./setup-interfaces 
# restart the networking to activate internet
/etc/init.d/networking restart
# configure the `apk` tool to an endpoint where it will fetch Alpine Linux packages
echo 1 | ./setup-apkrepos > /dev/null
# add the bridge package to enable bridging support
apk add bridge
# modify the host's interfaces file to use our own custom file (where bridging is included)
cp ./interfaces /etc/network/interfaces
# restart again to activate the bridged network
/etc/init.d/networking restart
# add all the necessary packages needed for lxc
apk add lxc lxc-templates
