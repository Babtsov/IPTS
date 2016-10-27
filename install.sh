echo "updating & upgrading APK"
apk update && apk upgrades

echo "adding git"
apk add git

echo "backing up to LBU"
lbu commit

echo "adding bash, bridge, and vim"
apk add bash bridge vim

echo "configuring networking on host..."
rm /etc/network/interfaces
cp host_config/interfaces /etc/network/interfaces
service networking restart
echo "testing networking..."
ping www.google.com -t 3


echo "adding lxc dependencies..."
apk add lxc lxc-templates
echo "creating lxc configuration..."
cp host_config/lxc.conf /etc/lxc/lxc.conf
service networking restar


echo "creating sip container..."
echo 0 > /proc/sys/kernel/grsecurity/chroot_caps
echo 0 > /proc/sys/kernel/grsecurity/chroot_deny_chroot
lxc-create -n sip -f /etc/lxc/lxc.conf -t alpine
echo "Sip Container created"
echo "including /var/lib/lxc in LBU"
lbu include /var/lib/lxc
echo "Starting sip container..."
lxc-start -name sip

cp sip_config /var/lib/lxc/sip/rootfs/tmp/
echo "executing sip_config inside container..."
lxc-attach -n sip -- /tmp/sip_config/config.sh
echo "done with config.sh inside sip"
