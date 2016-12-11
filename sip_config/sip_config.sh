#!/bin/sh
echo 'CONFIGURING NETWORK'
cp /root/sip_config/sip_network_interfaces /etc/network/interfaces
ifup eth0
apk update && apk upgrade

echo 'CONFIGURE Kamailio Installation'
apk add acf-postgresql
/etc/init.d/postgresql setup
sed "/^[# ]*log_destination/clog_destination = 'syslog'" -i /var/lib/postgresql/9.5/data/postgresql.conf
/etc/init.d/postgresql start && rc-update add postgresql
echo 'rc_after=pg-restore' > /etc/conf.d/kamailio
lbu include /var/lib/postgresql/
mkdir -p /var/lib/postgresql/backup
sed '/^[# ]*PGDUMP/cPGDUMP="/var/lib/postgresql/backup/databases.pgdump"' -i /etc/conf.d/pg-restore
rc-update add pg-restore
mkdir /etc/lbu/pre-package.d
echo "#!/bin/sh" > /etc/lbu/pre-package.d/postgresdump
echo "/etc/init.d/pg-restore dump" >> /etc/lbu/pre-package.d/postgresdump
chmod +x /etc/lbu/pre-package.d/postgresdump
apk add kamailio kamailio-presence kamailio-postgres
echo 'SED SED SED!'
sed '/^[# ]*SIP_DOMAIN/cSIP_DOMAIN=10.2.0.3' -i /etc/kamailio/kamctlrc
sed '/^[# ]*DBENGINE/cDBENGINE=PGSQL' -i /etc/kamailio/kamctlrc
sed '/^[# ]*DBHOST/cDBHOST=localhost' -i /etc/kamailio/kamctlrc
sed '/^[# ]*DBNAME/cDBNAME=openser' -i /etc/kamailio/kamctlrc
sed '/^[# ]*DBRWUSER/cDBRWUSER=openser' -i /etc/kamailio/kamctlrc
sed '/^[# ]*DBRWPW/cDBRWPW="openser"' -i /etc/kamailio/kamctlrc
sed '/^[# ]*DBROUSER/cDBROUSER=openserro' -i /etc/kamailio/kamctlrc
sed '/^[# ]*DBROPW/cDBROPW=openserro' -i /etc/kamailio/kamctlrc
sed '/^[# ]*DBROOTUSER/cDBROOTUSER="postgres" ' -i /etc/kamailio/kamctlrc
sed '/^[# ]*OSER_FIFO/cOSER_FIFO="/tmp/kamailio/kamailio_fifo" ' -i /etc/kamailio/kamctlrc

echo 'CREATE Kamailio database'
# workaround weird alpine bug, see https://bugs.alpinelinux.org/issues/3104"
cp /root/sip_config/kamdbctl.base /usr/lib/kamailio/kamctl/kamdbctl.base
echo postgres > /root/.pgpass 
chmod 600 /root/.pgpass 
yes|kamdbctl create openser

# Start Kamailio and setup for auto start on reboot
rc-update add kamailio 
echo 'rc_after=postgresql' >> /etc/conf.d/kamailio

# Create the directory for pid file:
# set ownership to /var/run/kamailio
mkdir -p /var/run/kamailio
chown kamailio:kamailio /var/run/kamailio
chown kamailio:kamailio /tmp
mkdir /tmp/kamailio
chown kamailio:kamailio /tmp/kamailio/

echo 'STARTING Kamailio'
/etc/init.d/kamailio start
echo 'DONE configuring kamailio'
