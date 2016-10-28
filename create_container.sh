
containerName=$1
echo ""
echo "CREATING AND RUNNING $containerName CONTAINER" 

lxc-create -n $containerName -f /etc/lxc/lxc.conf -t alpine
lxc-start -n $containerName 

echo ""
echo "CONTAINERS STATUS"
lxc-info -n $containerName | grep State

echo ""
echo "STARTING 'networking' SERVICE"
lxc-wait -n guest1 -t 1 
lxc-attach -n $containerName -- service networking status 
lxc-attach -n $containerName -- service networking start
