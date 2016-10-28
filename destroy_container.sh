
containerName=$1 
echo ""
echo "DESTROYING $containerName CONTAINER"
lxc-info -n $containerName | grep State
lxc-stop -n $containerName 
lxc-destroy -n $containerName
 
echo ""
echo "CONTAINER STATUS"
lxc-info -n $containerName
echo ""

