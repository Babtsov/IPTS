echo ""
echo "DESTROYING 'guest1' CONTAINER"
lxc-info -n guest1 | grep State
lxc-stop -n guest1
lxc-destroy -n guest1

echo ""
echo "CONTAINER STATUS"
lxc-info -n guest1
echo ""

