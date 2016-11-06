before_reboot(){
  ./init.sh
}

after_reboot(){
  ./spin_containers.sh
}

if [ -f /etc/rebootFlag.txt ]; then
    after_reboot
    rm /etc/rebootFlag.txt
    lbu ci
    update-rc.d install.sh remove
else
    before_reboot
    touch /var/run/rebooting-for-updates
    update-rc.d install.sh defaults
    reboot
fi
