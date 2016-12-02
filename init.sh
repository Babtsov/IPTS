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

echo "creating lxc configuration..."
cp host_config/lxc.conf /etc/lxc/lxc.conf

echo "creating sip container..."
lxc-create -n sip -f /etc/lxc/lxc.conf -t alpine
echo "Sip Container Created"
lxc-create -n sipmedia -f /etc/lxc/lxc.conf -t alpine
echo "Sip Media Container Created"

# echo "including /var/lib/lxc in LBU"
# lbu include /var/lib/lxc\

# a workaround that allows us to run lxc-attach
echo 0 > /proc/sys/kernel/grsecurity/chroot_caps
echo 0 > /proc/sys/kernel/grsecurity/chroot_deny_chroot

echo "starting sip container..."
lxc-start --name sip
cp -r sip_config /var/lib/lxc/sip/rootfs/tmp/

echo "Starting sip media container..."
lxc-start --name sipmedia
cp -r sip_config /var/lib/lxc/sipmedia/rootfs/tmp/

echo "executing sip_config inside containers..."
lxc-attach -n sip -- /tmp/sip_config/sip_config.sh
lxc-attach -n sipmedia  -- /tmp/sip_config/sipmedia_config.sh
lxc-attach -n sip -- rc-update add networking
lxc-attach -n sipmedia -- rc-update add networking


sleep 10
echo "restarting containers..."
lxc-stop --name sip
lxc-stop --name sipmedia
lxc-start --name sip
lxc-start --name sipmedia
sleep 10
echo "CONFIGURATION DONE"
echo "Configuring system to fasciliate debugging..."
./release.sh 		# make USB writeable
apk add git bash vim	# add git bash and vim

echo "Creating Reboot Flag"
touch /etc/rebootFlag.txt
echo "saving snapshot of current system..."
lbu ci
echo "rebooting..."
sleep 5
