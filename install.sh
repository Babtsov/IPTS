echo "Installing dependencies..."
apk add lxc lxc-templates bridge
echo "Preparing network on the host..."
cp host_config/interfaces /etc/network/interfaces
# restart network
ifconfig eth0 down
ifconfig eth0 up

cp host_config/lxc.conf /etc/lxc/lxc.conf

# workaround to ensure we can use lxc-attach
# see https://wiki.alpinelinux.org/wiki/Talk:LXC
echo 0 > /proc/sys/kernel/grsecurity/chroot_caps 
echo 0 > /proc/sys/kernel/grsecurity/chroot_deny_chroot

echo "Creating and configuring the sip container..."
lxc-create -n sip -f /etc/lxc/lxc.conf -t alpine
lxc-start --name sip

cp -r sip_config /var/lib/lxc/sip/rootfs/tmp/
lxc-attach -n sip -- /tmp/sip_config/config.sh
lxc-stop -n sip
lxc-start --name sip
echo "configuring sipmedia container..."
lxc-create -n sipmedia -f /etc/lxc/lxc.conf -t alpine
lxc-start --name sipmedia
echo "DONE with IPTS INSTALL"
