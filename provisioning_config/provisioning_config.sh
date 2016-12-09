#!/bin/sh
echo 'CONFIGURING NETWORK'
rm /etc/network/interfaces
touch /etc/network/interfaces
#cp /root/provisioning_config/provisioning_network_interfaces /etc/network/interfaces
cp /root/provisioning_config/denzel_provisioning_network_interfaces /etc/network/interfaces
service networking restart

rc-update add networking

# Configure remote administration
apk update && apk upgrade
setup-sshd -c openssh
apk add postgresql-dev python python-dev libpq gcc build-base zlib postgresql postgresql-client

# Setup postgresql
/etc/init.d/postgresql setup
sed "/^[# ]*log_destination/clog_destination = 'syslog'" -i /var/lib/postgresql/9.3/data/postgresql.conf
/etc/init.d/postgresql start
rc-update add postgresql
wget http://initd.org/psycopg/tarballs/PSYCOPG-2-5/psycopg2-2.5.2.tar.gz
tar -xzvf psycopg2-2.5.2.tar.gz
cd psycopg2-2.5.2
python setup.py install
