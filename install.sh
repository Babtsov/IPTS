echo "Installing dependencies..."
apk add lxc lxc-templates

echo "Transferring lxc configuration files..."
cp host_config/lxc.conf /etc/lxc/lxc.conf
cat /host_config/lxc.comf
echo "Restarting network service..."
/etc/init.d/networking restart
echo "Network service restarted."

# workaround to ensure we can use lxc-attach
# see https://wiki.alpinelinux.org/wiki/Talk:LXC
echo 0 > /proc/sys/kernel/grsecurity/chroot_caps
echo 0 > /proc/sys/kernel/grsecurity/chroot_deny_chroot

echo "Creating and configuring the sip container..."
lxc-create -n sip -f /etc/lxc/lxc.conf -t alpine
lxc-start --name sip

cp -r sip_config /var/lib/lxc/sip/rootfs/tmp/
echo "executing config.sh inside sip..."
lxc-attach -n sip -- /tmp/sip_config/config.sh
echo "done with config.sh inside sip"
echo "configuring sipmedia container..."
lxc-create -n sipmedia -f /etc/lxc/lxc.conf -t alpine
lxc-start --name sipmedia
echo "DONE with IPTS INSTALL"
