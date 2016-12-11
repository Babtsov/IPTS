
#This is the container name
name=$1

#Variable names
config="_config"
sh=".sh"
log=".log"
error=".error"
name_config=$name$config
name_config_sh=$name_config$sh
name_config_log=$name_config$log
name_config_error=$name_config$error


if [[ -n "$name" ]]; then
	echo " ------------- $name config ------------------"
	echo "CREATING $name container..." | tee -a ~/log/host_config.log
	lxc-create -n $name -f /etc/lxc/lxc.conf -t alpine >> ~/log/host_config.log
	echo "STARTING $name container..." | tee -a ~/log/host_config.log
	lxc-start --name $name 2>&1 | tee -a ~/log/host_config.log
	echo "TRANSFERRING script files into $name container" | tee -a ~/log/host_config.log
	cp -r $name_config /var/lib/lxc/$name/rootfs/root/
	echo "CONFIGURRING $name container" | tee -a ~/log/host_config.log
	lxc-attach -n $name -e -- /root/$name_config/$name_config_sh > ~/log/$name_config_log 2> ~/log/$name_config_error
	echo "DONE configuring $name. (see log at ~/log/$name_config_log)" | tee -a ~/log/host_config.log
else
	echo "Argument ERROR. Expected a container name."
fi
# ------------- sip config ------------------
#echo "CREATING sip container..." | tee -a ~/log/host_config.log
#lxc-create -n sip -f /etc/lxc/lxc.conf -t alpine >> ~/log/host_config.log
#echo "STARTING sip container..." | tee -a ~/log/host_config.log
#lxc-start --name sip 2>&1 | tee -a ~/log/host_config.log
#echo "TRANSFERRING script files into sip container" | tee -a ~/log/host_config.log
#cp -r sip_config /var/lib/lxc/sip/rootfs/root/
#echo "CONFIGURRING sip container" | tee -a ~/log/host_config.log
#lxc-attach -n sip -e -- /root/sip_config/sip_config.sh > ~/log/sip_config.log 2> ~/log/sip_config.error
#echo "DONE configuring sip. (see log at ~/log/sip_config.log)" | tee -a ~/log/host_config.log
