apk add lxc lxc-templates bridge
lxc-create -t alpine -n provisioning
lxc-start --name provisioning
