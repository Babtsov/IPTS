printf "\n" | ./setup-interfaces
/etc/init.d/networking restart
apk add bridge
cp ./interfaces /etc/network/interfaces
/etc/init.d/networking restart
echo 1 | ./setup-apkrepos > /dev/null
apk add lxc lxc-templates
