lxc-attach -n sip -- /tmp/container_config/sip_config.sh     #execute sip configuration file inside the sip container
lxc-attach -n sip -- rc-update add networking                #add network startup as part of default services
lxc-attach -n sip -- apk update                              #update apk manager
lxc-attach -n sip -- setup-sshd -c openssh                   #configure sshd
lxc-attach -n sip -- /etc/init.d/sshd start                  #start sshd on startup
lxc-attach -n sip -- setup-acf                               #setup acf
