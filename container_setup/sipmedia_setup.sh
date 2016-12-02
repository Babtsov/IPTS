lxc-attach -n sipmedia  -- /tmp/container_config/sipmedia_config.sh     #execute sipmedia configuration file inside the sipmedia container
lxc-attach -n sipmedia -- rc-update add networking                      #add network startup as part of the default services
lxc-attach -n sipmedia -- apk update                                         #update apk manager
lxc-attach -n sipmedia -- setup-sshd -c openssh                              #configure sshd
lxc-attach -n sipmedia -- /etc/init.d/sshd start                             #start sshd on startup
lxc-attach -n sipmedia -- setup-acf                                          #setup acf
