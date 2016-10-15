echo "Installing dependencies..."
apk add lxc lxc-templates bridge
apk add expect
echo "Creating containers..."
lxc-create -t alpine -n sip
lxc-create -t alpine -n sipmedia
lxc-start --name sip
lxc-start --name sipmedia
echo "configuring sip container..."
expect ./sip_config.exp
echo "configuring sipmedia container..."
expect ./sipmedia_config.exp
echo "DONE with IPTS INSTALL"
