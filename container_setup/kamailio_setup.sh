apk add acf-postgresql                                                                                        #add acf-postgresql
/etc/init.d/postgresql setup                                                                                  #configure postgresql setup
sed "/^[# ]*log_destination/clog_destination = 'syslog'" -i /var/lib/postgresql/9.3/data/postgresql.conf      #initialize postgresql configuration
/etc/init.d/postgresql start && rc-update add postgresql                                                      #start postgresql and add to default startup
echo 'rc_after=pg-restore' > /etc/conf.d/kamailio
lbu include /var/lib/postgresql/
mkdir -p /var/lib/postgresql/backup
sed '/^[# ]*PGDUMP/cPGDUMP="/var/lib/postgresql/backup/databases.pgdump"' -i /etc/conf.d/pg-restore
rc-update add pg-restore
mkdir /etc/lbu/pre-package.d
echo "#!/bin/sh" > /etc/lbu/pre-package.d/postgresdump
echo "/etc/init.d/pg-restore dump" >> /etc/lbu/pre-package.d/postgresdump chmod +x /etc/lbu/pre-package.d/postgresdump
apk add kamailio kamailio-presence kamailio-postgres
sed '/^[# ]*SIP_DOMAIN/cSIP_DOMAIN=10.2.0.3' -i /etc/kamailio/kamctlrc sed '/^[# ]*DBENGINE/cDBENGINE=PGSQL' -i /etc/kamailio/kamctlrc
sed '/^[# ]*DBHOST/cDBHOST=localhost' -i /etc/kamailio/kamctlrc
sed '/^[# ]*DBNAME/cDBNAME=openser' -i /etc/kamailio/kamctlrc
sed '/^[# ]*DBRWUSER/cDBRWUSER=openser' -i /etc/kamailio/kamctlrc sed '/^[# ]*DBRWPW/cDBRWPW="openser"' -i /etc/kamailio/kamctlrc
sed '/^[# ]*DBROUSER/cDBROUSER=openserro' -i /etc/kamailio/kamctlrc sed '/^[# ]*DBROPW/cDBROPW=openserro' -i /etc/kamailio/kamctlrc
sed '/^[# ]*DBROOTUSER/cDBROOTUSER="postgres" ' -i /etc/kamailio/kamctlrc
sed '/^[# ]*OSER_FIFO/cOSER_FIFO="/tmp/kamailio/kamailio_fifo" ' -i /etc/kamailio/kamctlrc





#TODO Configure postgresql and setup LBU backup for the database
