printf "\n" | ./setup-interfaces                                #keep pressing enter to setup a default temporary networking interface (using dhcp)
/etc/init.d/networking restart                                  #restart the networking to activate internet
echo 1 | ./setup-apkrepos > /dev/null                           #configure the `apk` tool to an endpoint where it will fetch Alpine Linux packages
echo 0 > /proc/sys/kernel/grsecurity/chroot_caps                 #a workaround that allows us to run lxc-attach
echo 0 > /proc/sys/kernel/grsecurity/chroot_deny_chroot

echo "updating network settings to activate bridge"
apk add bridge                                                  #adds the bridge dependencies
cp host_config/interfaces /etc/network/interfaces               #copies configuration file from usb to host network
service networking restart                                      #restarts the networking service
apk update && apk upgrade                                       #update and upgrade the apk manager

echo "Configuring LXC containers on host"
apk add lxc lxc-templates                                        #add LXC dependencies
lbu include /var/lib/lxc                                         #configuring containers for LBU backup
cp host_config/lxc.conf /etc/lxc/lxc.conf                        #copy container configuration from usb to host

echo "creating containers"
lxc-create -n sip -f /etc/lxc/lxc.conf -t alpine                 #create sip container
lxc-create -n sipmedia -f /etc/lxc/lxc.conf -t alpine            #create sipmedia container

echo "starting containers"
cp -r container_config /var/lib/lxc/sip/rootfs/tmp/              #copy sip configuration from usb to sip container directory on host
cp -r container_config /var/lib/lxc/sipmedia/rootfs/tmp/         #copy the sipmedia configuration from usb to sipmedia directory on host
lxc-start --name sip                                             #start the sip container
lxc-start --name sipmedia                                        #start the sipmedia container

echo "configuring containers"
./container_setup/sip_setup.sh                                   #sip container setup
./container_setup/sipmedia_setup.sh                              #sip media container setup
./container_setup/kamailio_setup.sh                              #kamailio setup


./container_setup/container_restart.sh

echo "Configuring system to faciliate debugging..."
./release.sh 		                                                  #make USB writeable
apk add git bash vim	                                            #add git bash and vim

echo "Creating Reboot Flag"
touch /etc/rebootFlag.txt
lbu ci
sleep 5



#TODO Figure out how to configure ACF on containers
#TODO Configure Kamailio
#TODO Configure FreeSWITCH
#TODO Configure DHCP/DNS Container
