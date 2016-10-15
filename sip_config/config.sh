touch /root/qaz.txt
mv /tmp/network_interfaces /etc/network/interfaces
/etc/init.d/networking start
rc-update add networking
apk update 
setup-sshd -c openssh 
/etc/init.d/sshd start
