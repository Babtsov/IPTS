echo "updating network settings to activate bridge"
apk add bridge
cp host_config/resolv.conf /etc/resolv.conf
cp host_config/interfaces /etc/network/interfaces
service networking restart
# configure the apk tool to an endpoint where it will fetch Alpine Linux packages
echo 1 | /media/usb/IPTS/setup-apkrepos > /dev/null
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
touch ~/log/host_config.log # create a log for the host_config itself

# ------------- sip config ------------------
./create_container.sh sip

# ------------- sipmedia config -------------
./create_container.sh sipmedia

# ------------- dhcpdns config -------------
./create_container.sh dhcpdns

# ------------- provisioning config --------
./create_container.sh provisioning

# ------------- debugging config ------------
echo "Configuring system to fasciliate debugging..."
./release.sh 		# make USB writeable
apk add git bash vim	# add git bash and vim

echo "CONFIGURATION DONE"
