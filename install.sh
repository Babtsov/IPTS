echo "updating network settings to activate bridge"
apk add bridge
cp host_config/resolv.conf /etc/resolv.conf
cp host_config/interfaces /etc/network/interfaces
service networking restart
# configure the apk tool to an endpoint where it will fetch Alpine Linux packages
echo 1 | /media/usb/IPTS/setup-apkrepos
echo "updating & upgrading apk"
apk update && apk upgrade

echo "adding lxc dependencies..."
apk add lxc lxc-templates

echo "CREATING lxc configuration..."
cp host_config/lxc.conf /etc/lxc/lxc.conf

# a workaround that allows us to run lxc-attach
echo 0 > /proc/sys/kernel/grsecurity/chroot_caps
echo 0 > /proc/sys/kernel/grsecurity/chroot_deny_chroot

echo "CREATING a log directory"
mkdir ~/log
# ------------- sip config ------------------
echo "CREATING sip container..."
lxc-create -n sip -f /etc/lxc/lxc.conf -t alpine
echo "STARTING sip container..."
lxc-start --name sip
echo "TRANSFERRING script files into sip container"
cp -r sip_config /var/lib/lxc/sip/rootfs/root/
echo "CONFIGURRING sip container"
lxc-attach -n sip -e -- /root/sip_config/sip_config.sh > ~/log/sip_config.log 2> ~/log/sip_config.error
echo "DONE configuring sip. (see log at ~/log/sip_config.log)"
exit 1
# ------------- sipmedia config -------------
echo "CREATING sipmedia container..."
lxc-create -n sipmedia -f /etc/lxc/lxc.conf -t alpine
echo "STARTING sip media container..."
lxc-start --name sipmedia
echo "TRANSFERRING script files into sipmedia container"
cp -r sipmedia_config /var/lib/lxc/sipmedia/rootfs/root/
lxc-attach -n sipmedia -e -- /root/sipmedia_config/sipmedia_config.sh > ~/log/sipmedia_config.log 2> ~/log/sipmedia_config.error
echo "DONE configuring sipmedia. (see log at ~/log/sipmedia_config.log)"
# ------------- dhcpdns config -------------
echo "CREATING dhcpdns container..."
lxc-create -n dhcpdns -f /etc/lxc/lxc.conf -t alpine
echo "STARTING dhcpdns container..."
lxc-start --name dhcpdns
echo "TRANSFERRING script files into dhcpdns container"
cp -r dhcpdns_config /var/lib/lxc/dhcpdns/rootfs/root/
lxc-attach -n dhcpdns -e -- /root/dhcpdns_config/dhcpdns_config.sh > ~/log/dhcpdns_config.log 2> ~/log/dhcpdns_config.error
echo "DONE configuring dhcpdns. (see log at ~/log/dhcpdns_config.log)"
# ------------- provisioning config --------
echo "CREATING provisioning container..."
lxc-create -n provisioning -f /etc/lxc/lxc.conf -t alpine
echo "STARTING provisioning container..."
lxc-start --name provisioning
echo "TRANSFERRING script files into provisioning container"
cp -r provisioning_config /var/lib/lxc/provisioning/rootfs/root/
lxc-attach -n provisioning -e -- /root/provisioning_config/provisioning_config.sh > ~/log/provisioning_config.log 2> ~/log/provisioning_config.error
echo "DONE configuring provisioning. (see log at ~/log/provisioning_config.log)"
# ------------- debugging config ------------
echo "Configuring system to fasciliate debugging..."
./release.sh 		# make USB writeable
apk add git bash vim	# add git bash and vim

echo "CONFIGURATION DONE"
