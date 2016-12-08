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

echo "CREATING sip container..."
lxc-create -n sip -f /etc/lxc/lxc.conf -t alpine

echo "STARTING sip container..."
lxc-start --name sip
echo "TRANSFERRING script files into sip container"
cp -r sip_config /var/lib/lxc/sip/rootfs/root/


# lxc-create -n sipmedia -f /etc/lxc/lxc.conf -t alpine
# echo "Sip Media Container Created"

# echo "Starting sip media container..."
# lxc-start --name sipmedia
# echo "configuring networking inside sipmedia"
# cp -r sip_config /var/lib/lxc/sipmedia/rootfs/tmp/
# lxc-attach -n sipmedia  -- /tmp/sip_config/sipmedia_config.sh
# echo "restarting networking inside sipmedia"
# lxc-attach -e -n sipmedia -- rc-update add networking

# echo "restarting containers..."
# lxc-stop --name sip
# lxc-stop --name sipmedia
# lxc-start --name sip
# lxc-start --name sipmedia

echo "CONFIGURATION DONE"
echo "Configuring system to fasciliate debugging..."
./release.sh 		# make USB writeable 
apk add git bash vim	# add git bash and vim
