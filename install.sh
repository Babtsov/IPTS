echo "restarting networking"
rm /etc/network/interfaces
touch /etc/network/interfaces
cp host_config/interfaces /etc/network/interfaces
service networking restart

echo "updating & upgrading APK"
apk update && apk upgrade

echo "adding git"
apk add git

echo "adding bash, bridge, and vim"
apk add bash bridge vim

echo "adding lxc dependencies..."
apk add lxc lxc-templates

echo "creating lxc configuration..."
cp host_config/lxc.conf /etc/lxc/lxc.conf
service networking restart

echo "creating sip container..."
echo 0 > /proc/sys/kernel/grsecurity/chroot_caps
echo 0 > /proc/sys/kernel/grsecurity/chroot_deny_chroot
lxc-create -n sip -f /etc/lxc/lxc.conf -t alpine
echo "Sip Container Created"
lxc-create -n sipmedia -f /etc/lxc/lxc.conf -t alpine
echo "Sip Media Container Created"

echo "including /var/lib/lxc in LBU"
lbu include /var/lib/lxc

echo "Starting sip container..."
lxc-start --name sip
echo "Starting sip media container..."
lxc-start --name sipmedia

cp -r sip_config /var/lib/lxc/sip/rootfs/tmp/
cp -r sip_config /var/lib/lxc/sipmedia/rootfs/tmp/

echo "executing sip_config inside containers..."
lxc-attach -n sip -- /tmp/sip_config/config.sh
lxc-attach -n sipmedia  -- /tmp/sip_config/config.sh
lxc-attach -n sip -- rc-update add networking
lxc-attach -n sipmedia -- rc-update add networking

echo "restarting containers..."
lxc-stop --name sip
lxc-stop --name sipmedia
lxc-start --name sip
lxc-start --name sipmedia

echo "done configuring"
