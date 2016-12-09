# keep pressing enter to setup a default temporary networking interface (using dhcp)
printf "\n" | ./setup-interfaces
# restart the networking to activate internet
/etc/init.d/networking restart
# configure the `apk` tool to an endpoint where it will fetch Alpine Linux packages
echo 1 | ./setup-apkrepos > /dev/null

echo "updating network settings to activate bridge"
apk add bridge
cp host_config/interfaces /etc/network/interfaces
service networking restart

echo "updating & upgrading apk"
apk update && apk upgrade

echo "adding lxc dependencies..."
apk add lxc lxc-templates

echo "CREATING lxc configuration..."
cp host_config/lxc.conf /etc/lxc/lxc.conf

# ------------- sip config ------------------
echo "CREATING sip container..."
lxc-create -n sip -f /etc/lxc/lxc.conf -t alpine
echo "STARTING sip container..."
lxc-start --name sip
echo "TRANSFERRING script files into sip container"
cp -r sip_config /var/lib/lxc/sip/rootfs/root/

# ------------- sipmedia config -------------
echo "CREATING sipmedia container..."
lxc-create -n sipmedia -f /etc/lxc/lxc.conf -t alpine
echo "STARTING sip media container..."
lxc-start --name sipmedia
echo "TRANSFERRING script files into sipmedia container"
cp -r sipmedia_config /var/lib/lxc/sipmedia/rootfs/root/

# ------------- dhcpdns config -------------
echo "CREATING dhcpdns container..."
lxc-create -n dhcpdns -f /etc/lxc/lxc.conf -t alpine
echo "STARTING sip media container..."
lxc-start --name dhcpdns
echo "TRANSFERRING script files into sipmedia container"
cp -r dhcpdns_config /var/lib/lxc/dhcpdns/rootfs/root/

# ------------- debugging config ------------
echo "Configuring system to fasciliate debugging..."
./release.sh 			# make USB writeable 
apk add git bash vim	# add git bash and vim

echo "CONFIGURATION DONE"
echo "Use lxc-console to configure each container individually"
# echo "lxc-console -n sip, and then run the config script inside of it"
