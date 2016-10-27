echo ""
echo "CREATING AND RUNNING 'guest1' CONTAINER" 

lxc-create -n guest1 -f /etc/lxc/lxc.conf -t alpine
lxc-start -n guest1

echo ""
echo "CONTAINERS STATUS"
lxc-info -n guest1 | grep State

echo ""
echo "STARTING 'networking' SERVICE"
lxc-wait -n guest1 -t 1 
lxc-attach -n guest1  -- service networking status 
lxc-attach -n guest1  -- service networking start
