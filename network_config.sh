echo "Installing dependencies..."
apk add bash bridge
echo "Configuring network"
cp host_config/interfaces /etc/network/interfaces
reboot
