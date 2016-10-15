echo "Installing dependencies..."
apk add lxc lxc-templates bridge
echo "Preparing network on the host..."
cp host_config/interfaces /etc/network/interfaces
cp host_config/lxc.conf /etc/lxc/lxc.conf
/etc/init.d/networking restart

# workaround to ensure we can use lxc-attach
# see https://wiki.alpinelinux.org/wiki/Talk:LXC
echo 0 > /proc/sys/kernel/grsecurity/chroot_caps 
echo 0 > /proc/sys/kernel/grsecurity/chroot_deny_chroot

echo "Creating containers..."
lxc-create -n sip -f /etc/lxc/lxc.conf -t alpine
lxc-create -n sipmedia -f /etc/lxc/lxc.conf -t alpine
lxc-start --name sip
lxc-start --name sipmedia

echo "configuring sip container..."
cp -r sip_config /var/lib/lxc/sip/rootfs/tmp/
lxc-attach -n sip -- /tmp/sip_config/config.sh
echo "configuring sipmedia container..."
echo "DONE with IPTS INSTALL"
