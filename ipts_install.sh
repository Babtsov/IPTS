echo "Installing dependencies..."
apk add lxc lxc-templates bridge
apk add expect
echo "Creating containers..."
lxc-create -t alpine -n sip
lxc-create -t alpine -n sipmedia
lxc-start --name sip
lxc-start --name sipmedia
if [ ! -d log ]; then
    mkdir log
fi
echo "configuring sip container..."
expect ./sip_config.exp >> ./log/sip_config.log
echo "configuring sipmedia container..."
expect ./sipmedia_config.exp >> ./log/sipmedia_config.log
echo "DONE with IPTS INSTALL"
