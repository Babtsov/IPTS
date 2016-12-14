echo "updating network settings to activate bridge"
apk add bridge # make sure we add bridge support before configuring network interfaces

. ip_space.cfg # export IP space variables from the configuration file
sed -i "" -e "s/lxc_host_ip/$lxc_host_ip/g" "host_config/interfaces"
sed -i "" -e "s/gateway_ip/$gateway_ip/g" "host_config/interfaces"

cp host_config/resolv.conf /etc/resolv.conf
cp host_config/interfaces /etc/network/interfaces
/etc/init.d/networking start
# configure the apk tool to an endpoint where it will fetch Alpine Linux packages & fetch most recent packages
echo 1 | /media/usb/IPTS/host_config/setup-apkrepos > /dev/null # and do so quietly
echo "updating & upgrading apk"
apk update && apk upgrade

echo "CONFIGURING remote SSH access"
apk add openssh
rc-update add sshd     # make sshd automatically start upon reboot
/etc/init.d/sshd start
mkdir ~/.ssh
cat host_config/ipts.pub >> ~/.ssh/authorized_keys   # append our public key to authorized keys
chmod 600 ~/.ssh/authorized_keys && chmod 700 ~/.ssh # adjust permissions so ssh doesn't complain

echo "adding lxc dependencies..."
apk add lxc lxc-templates
echo "CREATING lxc configuration..."
cp host_config/lxc.conf /etc/lxc/lxc.conf

# a workaround that allows us to run lxc-attach (see https://wiki.alpinelinux.org/wiki/Talk:LXC)
echo 0 > /proc/sys/kernel/grsecurity/chroot_caps
echo 0 > /proc/sys/kernel/grsecurity/chroot_deny_chroot

echo "CREATING a log directory"
mkdir ~/log
touch ~/log/host_config.log # create a log for the host_config itself


create_container() {
    local container_name=$1
    local container_name_ip="${container_name}_ip"
    eval "local container_ip_value=\${$container_name_ip}"
    sed -i "" -e "s/$container_name_ip/$container_ip_value/g" "${container_name}_config/${container_name}_network_interfaces"
    sed -i "" -e "s/gateway_ip/$gateway_ip/g" "${container_name}_config/${container_name}_network_interfaces"
    echo "CREATING $container_name container..." | tee -a ~/log/host_config.log
    lxc-create -n $container_name -f /etc/lxc/lxc.conf -t alpine >> ~/log/host_config.log
    echo "STARTING $container_name container..." | tee -a ~/log/host_config.log
    lxc-start --name $container_name 2>&1 | tee -a ~/log/host_config.log
    echo "TRANSFERRING script files into $container_name container" | tee -a ~/log/host_config.log
    cp -r ./${container_name}_config /var/lib/lxc/$container_name/rootfs/root/
    echo "CONFIGURRING $container_name container" | tee -a ~/log/host_config.log
    lxc-attach -n $container_name -e -- /root/${container_name}_config/${container_name}_config.sh > ~/log/${container_name}_config.log 2> ~/log/${container_name}_config.error
    echo "DONE configuring $container_name. (see log at ~/log/${container_name}_config.log)" | tee -a ~/log/host_config.log
}

create_container sip           # container for Kamailio
create_container sipmedia      # container for FreeSWITCH
create_container dhcpdns       # container for dhcp and dns servers
create_container provisioning  # container for the provisioning portal

echo "Configuring system to fasciliate debugging..."

./release.sh            # make USB writeable
apk add git bash vim    # add git bash and vim

echo "CONFIGURATION DONE"
